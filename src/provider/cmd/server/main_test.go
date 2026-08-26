package main

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/quanttide/qtclass-provider/internal/config"
)

// startMockUpstreams 起一个「API 网关」mock：同一基址下挂课程云与学习云两个子路径，
// 与生产部署形态（api.quanttide.com/{qtcloud-course,qtcloud-learn}）一致。
func startMockUpstreams(t *testing.T) *httptest.Server {
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
	learn.HandleFunc("POST /api/courses/prod/progress", func(w http.ResponseWriter, _ *http.Request) {
		w.Write([]byte(`{"max":3,"last":"lesson-2"}`))
	})
	learn.HandleFunc("POST /api/proposals", func(w http.ResponseWriter, _ *http.Request) {
		w.Write([]byte(`{"ok":true}`))
	})

	gateway := http.NewServeMux()
	gateway.Handle("/qtcloud-course/", http.StripPrefix("/qtcloud-course", course))
	gateway.Handle("/qtcloud-learn/", http.StripPrefix("/qtcloud-learn", learn))

	gw := httptest.NewServer(gateway)
	t.Cleanup(gw.Close)

	return gw
}

func TestRouter_EndToEnd(t *testing.T) {
	gw := startMockUpstreams(t)
	cfg := &config.Config{Addr: ":0", APIBaseURL: gw.URL}
	mux := buildRouter(cfg)

	do := func(method, path, body string) *httptest.ResponseRecorder {
		r := httptest.NewRequest(method, path, strings.NewReader(body))
		r.Header.Set("Content-Type", "application/json")
		if method == "POST" && path != "/proposals" { // proposals 由代理自身透传认证
			r.Header.Set("Authorization", "Bearer token-1")
		}
		w := httptest.NewRecorder()
		mux.ServeHTTP(w, r)
		return w
	}

	// 目录契约（wrapped 形态）
	w := do("GET", "/courses", "")
	if w.Code != 200 || !strings.Contains(w.Body.String(), `"status":"open"`) {
		t.Fatalf("GET /courses: %d %s", w.Code, w.Body.String())
	}

	// 播放器契约（完整链路：课程 → 课时 → 场景 + criteria 下发）
	w = do("GET", "/courses/prod/player", "")
	for _, want := range []string{`"pathSteps"`, `scen-1`, `"criteria":["cri-1"]`, `"action":"finish"`} {
		if !strings.Contains(w.Body.String(), want) {
			t.Fatalf("player data 缺少 %s：%s", want, w.Body.String())
		}
	}

	// 完成回写（白名单内 criterion，透传认证创建）
	w = do("POST", "/completions", `{"learner_id":"learner-001","criterion_id":"cri-1"}`)
	if w.Code != 200 || !strings.Contains(w.Body.String(), `"id":"com-new"`) {
		t.Fatalf("POST /completions: %d %s", w.Code, w.Body.String())
	}

	// 白名单外引用被拒
	w = do("POST", "/completions", `{"learner_id":"l-1","criterion_id":"not-defined"}`)
	if w.Code != 400 {
		t.Fatalf("unknown criterion status = %d", w.Code)
	}

	// 进度上报代理（学习云上游收到并返回）
	w = do("POST", "/progress", `{"moduleId":2,"name":"立项"}`)
	if w.Code != 200 || !strings.Contains(w.Body.String(), `"max":3`) {
		t.Fatalf("POST /progress: %d %s", w.Code, w.Body.String())
	}

	// 健康检查
	w = do("GET", "/healthz", "")
	if w.Code != 200 {
		t.Fatalf("healthz status = %d", w.Code)
	}
}
