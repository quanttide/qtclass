// 学习云网关代理：客户端只依赖 qtclass 服务端，
// 进度上报与立项等学习云调用由本服务转发（认证与请求体透传）。
package handler

import (
	"bytes"
	"io"
	"net/http"
	"strings"
)

// LearnProxy 把客户端的学习管理请求转发到学习云对应路径。
type LearnProxy struct {
	LearnBaseURL string
	HTTP         *http.Client
}

func NewLearnProxy(learnBaseURL string) *LearnProxy {
	return &LearnProxy{LearnBaseURL: strings.TrimRight(learnBaseURL, "/"), HTTP: &http.Client{}}
}

// 路径映射：客户端路径 → 学习云网关路径（上游语义不变）。
//
// /progress 与 /proposals 的上游端点已在 2026-08-27 qtcloud-learn 重构中移除，
// 当前为死链。生产实习进度上报与立项功能去留待果总决策，本轮先保留映射。
var learnRoutes = map[string]string{
	"/schedules":   "/schedules",
	"/tasks":       "/tasks",
	"/completions": "/completions",
	"/learners":    "/learners",
	"/progress":    "/api/courses/prod/progress",
	"/proposals":   "/api/proposals",
}

func (h *LearnProxy) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	upstreamPath, ok := mapLearnPath(r.URL.Path)
	if !ok {
		http.Error(w, `{"error":"not found"}`, http.StatusNotFound)
		return
	}
	auth := r.Header.Get("Authorization")
	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, `{"error":"invalid request body"}`, http.StatusBadRequest)
		return
	}

	target := h.LearnBaseURL + upstreamPath
	if r.URL.RawQuery != "" {
		target += "?" + r.URL.RawQuery
	}
	req, err := http.NewRequestWithContext(r.Context(), r.Method, target, bytes.NewReader(body))
	if err != nil {
		http.Error(w, `{"error":"internal error"}`, http.StatusInternalServerError)
		return
	}
	if contentType := r.Header.Get("Content-Type"); contentType != "" {
		req.Header.Set("Content-Type", contentType)
	} else {
		req.Header.Set("Content-Type", "application/json")
	}
	if auth != "" {
		req.Header.Set("Authorization", auth)
	}
	resp, err := h.HTTP.Do(req)
	if err != nil {
		http.Error(w, `{"error":"learn upstream unavailable"}`, http.StatusBadGateway)
		return
	}
	defer resp.Body.Close()

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(resp.StatusCode)
	io.Copy(w, resp.Body)
}

func mapLearnPath(path string) (string, bool) {
	if target, ok := learnRoutes[path]; ok {
		return target, true
	}
	for clientPath, upstreamPath := range learnRoutes {
		if strings.HasPrefix(path, clientPath+"/") {
			return upstreamPath + strings.TrimPrefix(path, clientPath), true
		}
	}
	return "", false
}
