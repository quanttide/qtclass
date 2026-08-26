// 完成回写代理：白名单校验 + learner × criterion 幂等。
package handler

import (
	"encoding/json"
	"net/http"
	"strings"

	"github.com/quanttide/qtclass-provider/internal/upstream"
)

// CompletionProxy 把播放器的验收判定透传为学习云完成记录。
// 白名单：仅接受课程云 Criterion 全局清单中存在的 id（防伪造引用）。
// 幂等：learner × criterion 已有记录时翻状态（PUT），否则创建（POST）。
type CompletionProxy struct {
	Course *upstream.CourseClient
	Learn  *upstream.LearnClient
}

func NewCompletionProxy(course *upstream.CourseClient, learn *upstream.LearnClient) *CompletionProxy {
	return &CompletionProxy{Course: course, Learn: learn}
}

type completionRequest struct {
	LearnerID   string `json:"learner_id"`
	CriterionID string `json:"criterion_id"`
	Status      string `json:"status"` // 可选，默认 completed
}

func (h *CompletionProxy) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	var req completionRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error":"invalid request body"}`, http.StatusBadRequest)
		return
	}
	if req.LearnerID == "" || req.CriterionID == "" {
		http.Error(w, `{"error":"learner_id and criterion_id are required"}`, http.StatusBadRequest)
		return
	}
	status := req.Status
	if status == "" {
		status = "completed"
	}
	if status != "completed" && status != "not_completed" {
		http.Error(w, `{"error":"status must be completed or not_completed"}`, http.StatusBadRequest)
		return
	}
	auth := r.Header.Get("Authorization")
	if auth == "" {
		http.Error(w, `{"error":"authorization required"}`, http.StatusUnauthorized)
		return
	}
	ctx := r.Context()

	// 白名单校验：criterion 必须由课程云定义
	criteria, err := h.Course.Criteria(ctx)
	if err != nil {
		http.Error(w, `{"error":"course upstream unavailable"}`, http.StatusBadGateway)
		return
	}
	known := false
	for _, c := range criteria {
		if c.ID == req.CriterionID {
			known = true
			break
		}
	}
	if !known {
		http.Error(w, `{"error":"unknown criterion_id"}`, http.StatusBadRequest)
		return
	}

	// 幂等：已有记录则翻状态，否则创建
	existing, err := h.Learn.Completions(ctx, auth)
	if err != nil {
		http.Error(w, `{"error":"learn upstream unavailable"}`, http.StatusBadGateway)
		return
	}
	for _, c := range existing {
		if c.LearnerID == req.LearnerID && strings.EqualFold(c.CriterionID, req.CriterionID) {
			if err := h.Learn.UpdateStatus(ctx, auth, c.ID, status); err != nil {
				http.Error(w, `{"error":"learn update failed"}`, http.StatusBadGateway)
				return
			}
			writeJSON(w, http.StatusOK, map[string]any{"id": c.ID, "status": status})
			return
		}
	}
	payload := map[string]any{"learner_id": req.LearnerID, "criterion_id": req.CriterionID, "status": status}
	created, err := h.Learn.CreateCompletion(ctx, auth, payload)
	if err != nil {
		http.Error(w, `{"error":"learn create failed"}`, http.StatusBadGateway)
		return
	}
	writeJSON(w, http.StatusOK, created)
}

func writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(v)
}
