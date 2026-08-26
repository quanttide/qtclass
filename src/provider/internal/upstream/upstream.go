// Package upstream 定义课程云与学习云的 HTTP 客户端与内容实体类型。
// 实体 JSON 字段名对齐各领域 provider 的响应契约（同源直连 id）。
package upstream

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
)

// Course 是课程云课程实体（只声明本服务消费的字段）。
type Course struct {
	ID          string `json:"id"`
	Name        string `json:"name"`
	Slug        string `json:"slug"`
	Description string `json:"description,omitempty"`
	Status      string `json:"status,omitempty"`    // draft / published
	SortOrder   int    `json:"sortOrder,omitempty"` // 目录阶梯顺序
}

// Lesson 是课程域课时实体。
type Lesson struct {
	ID           string   `json:"id"`
	CourseID     string   `json:"courseId"`
	Title        string   `json:"title"`
	Slug         string   `json:"slug"`
	Description  string   `json:"description,omitempty"`
	Duration     int      `json:"duration,omitempty"`
	SortOrder    int      `json:"sortOrder,omitempty"`
	Status       string   `json:"status,omitempty"`
	StartSceneID string   `json:"startSceneId,omitempty"`
	Criteria     []string `json:"criteria,omitempty"` // 引用的 Criterion ID 列表
}

// Scene 是课程域场景实体。
type Scene struct {
	ID        string   `json:"id"`
	LessonID  string   `json:"lessonId"`
	Title     string   `json:"title,omitempty"`
	Slug      string   `json:"slug"`
	VideoURL  string   `json:"videoUrl,omitempty"`
	VerifyTip string   `json:"verifyTip,omitempty"`
	Criteria  []string `json:"criteria,omitempty"`
}

// Criterion 是课程域验收标准实体。
type Criterion struct {
	ID          string `json:"id"`
	LessonID    string `json:"lessonId"`
	SceneID     string `json:"sceneId,omitempty"`
	Title       string `json:"title"`
	Description string `json:"description"`
}

func trimSlash(s string) string { return strings.TrimRight(s, "/") }

// fetchJSON 发起 GET 并解码为 T（非 200 视为错误）。
func fetchJSON[T any](ctx context.Context, client *http.Client, url string, out *T) error {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return err
	}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("upstream %s: HTTP %d", url, resp.StatusCode)
	}
	return json.NewDecoder(resp.Body).Decode(out)
}

// CourseClient 对接课程云。
type CourseClient struct {
	BaseURL string
	HTTP    *http.Client
}

func NewCourseClient(baseURL string) *CourseClient {
	return &CourseClient{BaseURL: trimSlash(baseURL), HTTP: &http.Client{}}
}

func (c *CourseClient) Courses(ctx context.Context) ([]Course, error) {
	var out []Course
	err := fetchJSON(ctx, c.HTTP, c.BaseURL+"/courses", &out)
	return out, err
}

func (c *CourseClient) Lessons(ctx context.Context, courseID string) ([]Lesson, error) {
	var out []Lesson
	err := fetchJSON(ctx, c.HTTP, c.BaseURL+"/courses/"+courseID+"/lessons", &out)
	return out, err
}

func (c *CourseClient) Scenes(ctx context.Context, lessonID string) ([]Scene, error) {
	var out []Scene
	err := fetchJSON(ctx, c.HTTP, c.BaseURL+"/lessons/"+lessonID+"/scenes", &out)
	return out, err
}

// Criteria 返回全局标准清单（快照注册管道的数据源同款接口）。
func (c *CourseClient) Criteria(ctx context.Context) ([]Criterion, error) {
	var out []Criterion
	err := fetchJSON(ctx, c.HTTP, c.BaseURL+"/criteria", &out)
	return out, err
}
