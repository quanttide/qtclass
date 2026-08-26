package main

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/quanttide/qtclass-provider/internal/config"
)

// startMockUpstreams 起课程云与学习云的最小 mock。
func startMockUpstreams(t *testing.T) (*httptest.Server, *httptest.Server) {
	t.Helper()
	course := http.NewServeMux()
	course.HandleFunc("GET /courses", func(w http.ResponseWriter, _ *http.Request) {
		w.Write([]byte(`[{"id":"prod","name":"生产实习","status":"published","sortOrder":1}]`))
	})
	course.HandleFunc("GET /criteria", func(w http.ResponseWriter, _ *http.Request) {
		w.Write([]byte(`[{"id":"cri-1","lessonId":"less-1","title":"会连接 Zed"}]`))
	})
	course.HandleFunc("GET /courses/prod/lessons", func(w http.ResponseWriter, _ *http.Request) {
		w.Write([]byte(`[{"id":"less-1","courseId":"prod","title":"创立故事","sortOrder":1,"criteria":["cri-1"]}]`))
	})
	course.HandleFunc("GET /lessons/less-1/scenes", func(w http.ResponseWriter, _ *http.Request) {
		w.Write([]byte(`[{"id":"scen-1","lessonId":"less-1","title":"开场","slug":"open","verifyTip":"确认 Zed 已启动","criteria":["cri-1"]}]`))
	})

	learn := http.NewServeMux()
	learn.HandleFunc("GET /completions", func(w http.ResponseWriter, _ *http.Request) {
		w.Write([]byte(`[]`))
	})
	learn.HandleFunc("POST /completions", func(w http.ResponseWriter, r *http.Request) {
		if r.Header.Get("Authorization") == "" {
			w.WriteHeader(http.StatusUnauthorized)
			return
		}
		w.Write([]byte(`{"id":"com-new"}`))
	})

	cs := httptest.NewServer(course)
	ls := httptest.NewServer(learn)
	t.Cleanup(cs.Close)
	t.Cleanup(ls.Close)
	return cs, ls
}

func TestRouter_EndToEnd(t *testing.T) {
	cs, ls := startMockUpstreams(t)
	cfg := &config.Config{Addr: ":0", CourseAPI: cs.URL, LearnAPI: ls.URL}
	mux := buildRouter(cfg)

	do := func(method, path string) (*httptest.ResponseRecorder, *http.Request) {
		r := httptest.NewRequest(method, path, strings.NewReader(
			`{"learner_id":"learner-001","criterion_id":"cri-1"}`))
		if method == "POST" {
			r.Header.Set("Authorization", "Bearer token-1")
			r.Header.Set("Content-Type", "application/json")
		}
		w := httptest.NewRecorder()
		mux.ServeHTTP(w, r)
		return w, r
	}

	// 目录契约
	w, _ := do("GET", "/courses")
	if w.Code != 200 || !strings.Contains(w.Body.String(), `"status":"open"`) {
		t.Fatalf("GET /courses: %d %s", w.Code, w.Body.String())
	}

	// 播放器契约（完整链路：课程 → 课时 → 场景 + criteria 下发）
	w, _ = do("GET", "/courses/prod/player")
	for _, want := range []string{`"pathSteps"`, `scen-1`, `"criteria":["cri-1"]`, `"action":"finish"`} {
		if !strings.Contains(w.Body.String(), want) {
			t.Fatalf("player data 缺少 %s：%s", want, w.Body.String())
		}
	}

	// 完成回写（白名单内 criterion，透传认证创建）
	w, _ = do("POST", "/completions")
	if w.Code != 200 || !strings.Contains(w.Body.String(), `"id":"com-new"`) {
		t.Fatalf("POST /completions: %d %s", w.Code, w.Body.String())
	}

	// 白名单外引用被拒
	w = httptest.NewRecorder()
	body := strings.NewReader(`{"learner_id":"l-1","criterion_id":"not-defined"}`)
	r := httptest.NewRequest("POST", "/completions", body)
	r.Header.Set("Authorization", "Bearer token-1")
	mux.ServeHTTP(w, r)
	if w.Code != 400 {
		t.Fatalf("unknown criterion status = %d", w.Code)
	}

	// 健康检查
	w = httptest.NewRecorder()
	mux.ServeHTTP(w, httptest.NewRequest("GET", "/healthz", nil))
	if w.Code != 200 {
		t.Fatalf("healthz status = %d", w.Code)
	}
}
