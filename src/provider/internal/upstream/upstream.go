// Package upstream 定义课程云与学习云的 HTTP 客户端。
// 内容实体复用 course-toolkit 的领域模型（type alias），与服务端 API 字段一一对应。
package upstream

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strings"

	course "github.com/quanttide/quanttide-course-toolkit/packages/go/pkg"
)

type (
	// Course 是课程云课程实体。
	Course = course.Course
	// Lesson 是课程域课时实体（Criteria 引用的 Criterion ID 列表）。
	Lesson = course.Lesson
	// Scene 是课程域场景实体。
	Scene = course.Scene
	// Criterion 是课程域验收标准实体。
	Criterion = course.Criterion
)

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
	err := fetchJSON(ctx, c.HTTP, c.BaseURL+course.RouteCourses, &out)
	return out, err
}

func (c *CourseClient) Lessons(ctx context.Context, courseID string) ([]Lesson, error) {
	var out []Lesson
	err := fetchJSON(ctx, c.HTTP, c.BaseURL+course.CourseLessonsPath(courseID), &out)
	return out, err
}

func (c *CourseClient) Scenes(ctx context.Context, lessonID string) ([]Scene, error) {
	var out []Scene
	err := fetchJSON(ctx, c.HTTP, c.BaseURL+course.LessonScenesPath(lessonID), &out)
	return out, err
}

// Criteria 返回全局标准清单（快照注册管道的数据源同款接口）。
func (c *CourseClient) Criteria(ctx context.Context) ([]Criterion, error) {
	var out []Criterion
	err := fetchJSON(ctx, c.HTTP, c.BaseURL+course.RouteCriteria, &out)
	return out, err
}
