package upstream

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
)

// LearnClient 对接学习云网关。
type LearnClient struct {
	BaseURL string
	HTTP    *http.Client
}

func NewLearnClient(baseURL string) *LearnClient {
	return &LearnClient{BaseURL: trimSlash(baseURL), HTTP: &http.Client{}}
}

// Completion 是学习云完成记录实体（跨域引用 criterion_id）。
type Completion struct {
	ID          string `json:"id"`
	LearnerID   string `json:"learner_id"`
	CriterionID string `json:"criterion_id"`
	Status      string `json:"status"`
}

// Completions 列出完成记录。auth 为调用方的 Authorization 头原值。
func (c *LearnClient) Completions(ctx context.Context, auth string) ([]Completion, error) {
	var out []Completion
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, c.BaseURL+"/completions", nil)
	if err != nil {
		return nil, err
	}
	if auth != "" {
		req.Header.Set("Authorization", auth)
	}
	resp, err := c.HTTP.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("learn completions: HTTP %d", resp.StatusCode)
	}
	return out, json.NewDecoder(resp.Body).Decode(&out)
}

// CreateCompletion 创建完成记录（透传认证），返回学习云落库后的记录。
func (c *LearnClient) CreateCompletion(ctx context.Context, auth string, payload map[string]any) (map[string]any, error) {
	body, err := json.Marshal(payload)
	if err != nil {
		return nil, err
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.BaseURL+"/completions", bytes.NewReader(body))
	if err != nil {
		return nil, err
	}
	req.Header.Set("Content-Type", "application/json")
	if auth != "" {
		req.Header.Set("Authorization", auth)
	}
	resp, err := c.HTTP.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusCreated && resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("learn create completion: HTTP %d", resp.StatusCode)
	}
	var out map[string]any
	if err := json.NewDecoder(resp.Body).Decode(&out); err != nil {
		return nil, err
	}
	return out, nil
}

// UpdateStatus 局部更新完成记录状态。
func (c *LearnClient) UpdateStatus(ctx context.Context, auth, id, status string) error {
	payload, _ := json.Marshal(map[string]string{"status": status})
	req, err := http.NewRequestWithContext(ctx, http.MethodPut, c.BaseURL+"/completions/"+id, bytes.NewReader(payload))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")
	if auth != "" {
		req.Header.Set("Authorization", auth)
	}
	resp, err := c.HTTP.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("learn update completion %s: HTTP %d", id, resp.StatusCode)
	}
	return nil
}
