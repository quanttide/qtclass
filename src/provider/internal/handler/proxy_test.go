package handler

import (
	"bytes"
	"net/http/httptest"
	"testing"

	"github.com/quanttide/qtclass-provider/internal/upstream"
)

// newProxy 组装已注入 mock 上游的 CompletionProxy。
func newProxy(t *testing.T) (*CompletionProxy, *learnCapture) {
	cs, ls, cap := mockUpstreams(t, []learnCompletion{
		{ID: "com-1", LearnerID: "learner-001", CriterionID: "cri-1", Status: "not_completed"},
	})
	return NewCompletionProxy(upstream.NewCourseClient(cs.URL), upstream.NewLearnClient(ls.URL)), cap
}

func callProxy(t *testing.T, p *CompletionProxy, body string, withAuth bool) *httptest.ResponseRecorder {
	t.Helper()
	r := httptest.NewRequest("POST", "/completions", bytes.NewReader([]byte(body)))
	if withAuth {
		r.Header.Set("Authorization", "Bearer token-1")
	}
	w := httptest.NewRecorder()
	p.ServeHTTP(w, r)
	return w
}

func TestCompletionProxy_Create(t *testing.T) {
	p, cap := newProxy(t)
	w := callProxy(t, p, `{"learner_id":"learner-002","criterion_id":"cri-2","status":"completed"}`, true)
	if w.Code != 200 {
		t.Fatalf("status = %d; body=%s", w.Code, w.Body.String())
	}
	if len(cap.created) != 1 {
		t.Fatalf("created = %d 次，want 1", len(cap.created))
	}
	body := cap.created[0]
	if body["learner_id"] != "learner-002" || body["criterion_id"] != "cri-2" || body["status"] != "completed" {
		t.Fatalf("payload = %v", body)
	}
}

func TestCompletionProxy_IdempotentUpdate(t *testing.T) {
	p, cap := newProxy(t)
	// cri-1 已有 not_completed 记录 → 应 PUT 翻状态而非再创建
	w := callProxy(t, p, `{"learner_id":"learner-001","criterion_id":"cri-1","status":"completed"}`, true)
	if w.Code != 200 {
		t.Fatalf("status = %d", w.Code)
	}
	if len(cap.created) != 0 {
		t.Fatalf("created = %d 次，want 0（幂等应走更新）", len(cap.created))
	}
	if cap.putStatusByID["com-1"] != "completed" {
		t.Fatalf("put status = %v", cap.putStatusByID)
	}
}

func TestCompletionProxy_WhitelistRejectsUnknownCriterion(t *testing.T) {
	p, _ := newProxy(t)
	w := callProxy(t, p, `{"learner_id":"l-1","criterion_id":"unknown-cri"}`, true)
	if w.Code != 400 || !bytes.Contains(w.Body.Bytes(), []byte("unknown criterion_id")) {
		t.Fatalf("status = %d; body = %s", w.Code, w.Body.String())
	}
}

func TestCompletionProxy_AuthRequired(t *testing.T) {
	p, _ := newProxy(t)
	w := callProxy(t, p, `{"learner_id":"l-1","criterion_id":"cri-1"}`, false)
	if w.Code != 401 {
		t.Fatalf("status = %d, want 401", w.Code)
	}
}

func TestCompletionProxy_BadStatus(t *testing.T) {
	p, _ := newProxy(t)
	w := callProxy(t, p, `{"learner_id":"l-1","criterion_id":"cri-1","status":"done"}`, true)
	if w.Code != 400 {
		t.Fatalf("status = %d, want 400", w.Code)
	}
}

func TestCompletionProxy_MissingFields(t *testing.T) {
	p, cap := newProxy(t)
	for i, body := range []string{
		`{"criterion_id":"cri-1"}`,
		`{"learner_id":"l-1"}`,
	} {
		w := callProxy(t, p, body, true)
		if w.Code != 400 {
			t.Errorf("case %d: status = %d, want 400", i, w.Code)
		}
	}
	// 空 body：解码失败也返回 400
	w := callProxy(t, p, `{`, true)
	if w.Code != 400 {
		t.Errorf("invalid JSON: status = %d, want 400", w.Code)
	}
	if len(cap.created) != 0 || len(cap.putStatusByID) != 0 {
		t.Fatal("校验失败的请求不应触达学习云")
	}
}
