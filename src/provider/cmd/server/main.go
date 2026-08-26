package main

import (
	"log"
	"net/http"

	"github.com/quanttide/qtclass-provider/internal/config"
	"github.com/quanttide/qtclass-provider/internal/handler"
	"github.com/quanttide/qtclass-provider/internal/upstream"
)

func main() {
	cfg := config.Load()
	mux := buildRouter(cfg)
	log.Printf("qtclass-provider starting on %s (course=%s learn=%s)", cfg.Addr, cfg.CourseBase(), cfg.LearnBase())
	if err := http.ListenAndServe(cfg.Addr, mux); err != nil {
		log.Fatalf("server error: %v", err)
	}
}

// buildRouter 组装路由。本服务无独立存储：读请求实时聚合课程云，
// 完成回写透传学习云（learner × criterion 幂等）。
func buildRouter(cfg *config.Config) *http.ServeMux {
	course := upstream.NewCourseClient(cfg.CourseBase())
	learn := upstream.NewLearnClient(cfg.LearnBase())

	playerHandler := handler.NewPlayerHandler(course)
	completionProxy := handler.NewCompletionProxy(course, learn)
	learnProxy := handler.NewLearnProxy(cfg.LearnBase())

	mux := http.NewServeMux()

	// Studio 契约入口
	mux.HandleFunc("GET /courses", playerHandler.List)
	mux.HandleFunc("GET /player-data", playerHandler.Default)
	mux.HandleFunc("GET /courses/{id}/player", func(w http.ResponseWriter, r *http.Request) {
		playerHandler.PlayerData(w, r, r.PathValue("id"))
	})

	// 完成回写代理
	mux.HandleFunc("POST /completions", completionProxy.ServeHTTP)

	// 学习云代理（进度上报 / 立项）
	mux.HandleFunc("POST /progress", learnProxy.ServeHTTP)
	mux.HandleFunc("POST /proposals", learnProxy.ServeHTTP)

	// Health
	mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, _ *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("ok\n"))
	})

	return mux
}
