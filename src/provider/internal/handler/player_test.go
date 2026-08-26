package handler

import (
	"encoding/json"
	"net/http/httptest"
	"testing"

	"github.com/quanttide/qtclass-provider/internal/upstream"
)

// newPlayer 组装已注入课程云 mock 的 PlayerHandler。
func newPlayer(t *testing.T) *PlayerHandler {
	cs, _, _ := mockUpstreams(t, nil)
	return NewPlayerHandler(upstream.NewCourseClient(cs.URL))
}

func TestPlayerHandler_List_WrappedContract(t *testing.T) {
	h := newPlayer(t)
	w := httptest.NewRecorder()
	h.List(w, httptest.NewRequest("GET", "/courses", nil))
	if w.Code != 200 {
		t.Fatalf("status = %d", w.Code)
	}
	var out struct {
		Courses []map[string]any `json:"courses"`
	}
	if err := json.Unmarshal(w.Body.Bytes(), &out); err != nil {
		t.Fatalf("decode: %v; body=%s", err, w.Body.String())
	}
	if len(out.Courses) != 1 || out.Courses[0]["id"] != "prod" || out.Courses[0]["status"] != "open" {
		t.Fatalf("courses = %+v", out.Courses)
	}
}

func TestPlayerHandler_PlayerData_Contract(t *testing.T) {
	h := newPlayer(t)
	w := httptest.NewRecorder()
	h.PlayerData(w, httptest.NewRequest("GET", "/courses/prod/player", nil), "prod")
	if w.Code != 200 {
		t.Fatalf("status = %d; body=%s", w.Code, w.Body.String())
	}
	var data struct {
		Title    string `json:"title"`
		Segments map[string]struct {
			ID         string   `json:"id"`
			Duration   float64  `json:"duration"`
			Caption    string   `json:"caption"`
			Chapter    string   `json:"chapter"`
			PathStepID string   `json:"pathStepId"`
			Action     string   `json:"action"`
			Criteria   []string `json:"criteria"`
		} `json:"segments"`
		PathSteps []struct {
			ID        string `json:"id"`
			Label     string `json:"label"`
			SegmentID string `json:"segmentId"`
		} `json:"pathSteps"`
	}
	if err := json.Unmarshal(w.Body.Bytes(), &data); err != nil {
		t.Fatalf("decode: %v", err)
	}
	if data.Title != "生产实习" {
		t.Fatalf("title = %q", data.Title)
	}
	if len(data.Segments) != 1 || len(data.PathSteps) != 1 {
		t.Fatalf("segments=%d pathSteps=%d", len(data.Segments), len(data.PathSteps))
	}
	seg := data.Segments["scen-1"]
	if seg.PathStepID != "less-1" || seg.Action != "finish" || seg.Caption != "确认 Zed 已启动" {
		t.Fatalf("segment = %+v", seg)
	}
	if len(seg.Criteria) == 0 {
		t.Fatal("criteria 关联组未随契约下发")
	}
	if data.PathSteps[0].Label != "创立故事" || data.PathSteps[0].SegmentID != "scen-1" {
		t.Fatalf("pathSteps = %+v", data.PathSteps)
	}

	// 不存在的课程
	w2 := httptest.NewRecorder()
	h.PlayerData(w2, httptest.NewRequest("GET", "/courses/nope/player", nil), "nope")
	if w2.Code != 404 {
		t.Fatalf("not found status = %d", w2.Code)
	}
}

func TestPlayerHandler_Default_FallbackFirstPublished(t *testing.T) {
	h := newPlayer(t)
	w := httptest.NewRecorder()
	h.Default(w, httptest.NewRequest("GET", "/player-data", nil))
	if w.Code != 200 || !json.Valid(w.Body.Bytes()) {
		t.Fatalf("status = %d body = %s", w.Code, w.Body.String())
	}
}
