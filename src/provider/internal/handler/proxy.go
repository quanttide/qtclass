// 学习云网关代理：客户端只依赖 qtclass 服务端，
// 进度上报与立项等学习云调用由本服务转发（认证与请求体透传）。
package handler

import (
	"bytes"
	"io"
	"net/http"
	"strings"
)

// LearnProxy 把客户端的进度/立项请求转发到学习云对应路径。
type LearnProxy struct {
	LearnBaseURL string
	HTTP         *http.Client
}

func NewLearnProxy(learnBaseURL string) *LearnProxy {
	return &LearnProxy{LearnBaseURL: strings.TrimRight(learnBaseURL, "/"), HTTP: &http.Client{}}
}

// 路径映射：客户端路径 → 学习云网关路径（上游语义不变）。
var learnRoutes = map[string]string{
	"/progress":  "/api/courses/prod/progress", // 当前唯一上线课程
	"/proposals": "/api/proposals",
}

func (h *LearnProxy) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	upstreamPath, ok := learnRoutes[r.URL.Path]
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

	req, err := http.NewRequestWithContext(r.Context(), http.MethodPost, h.LearnBaseURL+upstreamPath, bytes.NewReader(body))
	if err != nil {
		http.Error(w, `{"error":"internal error"}`, http.StatusInternalServerError)
		return
	}
	req.Header.Set("Content-Type", "application/json")
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
