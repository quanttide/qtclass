// 播放器数据组装接口：读课程云内容实体，输出 Studio 播放器契约。
package handler

import (
	"net/http"
	"sort"

	"github.com/quanttide/qtclass-provider/internal/player"
	"github.com/quanttide/qtclass-provider/internal/upstream"
)

// PlayerHandler 提供课程目录与播放器数据（Studio 契约形态）。
type PlayerHandler struct {
	Course *upstream.CourseClient
}

func NewPlayerHandler(course *upstream.CourseClient) *PlayerHandler {
	return &PlayerHandler{Course: course}
}

// List GET /courses：Studio 课程目录契约（{"courses":[...]}，icon/badge 缺省由客户端兜底）。
func (h *PlayerHandler) List(w http.ResponseWriter, r *http.Request) {
	courses, err := h.Course.Courses(r.Context())
	if err != nil {
		http.Error(w, `{"error":"course upstream unavailable"}`, http.StatusBadGateway)
		return
	}
	sort.SliceStable(courses, func(i, j int) bool {
		return courses[i].SortOrder < courses[j].SortOrder
	})
	out := make([]map[string]any, 0, len(courses))
	for _, c := range courses {
		status := "locked"
		if c.Status == "published" {
			status = "open"
		}
		out = append(out, map[string]any{
			"id":     c.ID,
			"name":   c.Name,
			"desc":   c.Description,
			"status": status,
			"meta":   map[string]any{},
		})
	}
	writeJSON(w, http.StatusOK, map[string]any{"courses": out})
}

// PlayerData GET /courses/{id}/player：播放器契约。
func (h *PlayerHandler) PlayerData(w http.ResponseWriter, r *http.Request, courseID string) {
	courses, err := h.Course.Courses(r.Context())
	if err != nil {
		http.Error(w, `{"error":"course upstream unavailable"}`, http.StatusBadGateway)
		return
	}
	var found *upstream.Course
	for _, c := range courses {
		if c.ID == courseID {
			found = &c
			break
		}
	}
	if found == nil {
		http.Error(w, `{"error":"course not found"}`, http.StatusNotFound)
		return
	}
	h.writePlayerData(w, r, *found)
}

// Default GET /player-data：首个 published 课程的播放数据（旧客户端兼容入口）。
func (h *PlayerHandler) Default(w http.ResponseWriter, r *http.Request) {
	courses, err := h.Course.Courses(r.Context())
	if err != nil {
		http.Error(w, `{"error":"course upstream unavailable"}`, http.StatusBadGateway)
		return
	}
	for _, c := range courses {
		if c.Status == "published" {
			h.writePlayerData(w, r, c)
			return
		}
	}
	http.Error(w, `{"error":"no published course"}`, http.StatusNotFound)
}

// writePlayerData 聚合四资源并输出播放器契约。
func (h *PlayerHandler) writePlayerData(w http.ResponseWriter, r *http.Request, course upstream.Course) {
	ctx := r.Context()
	criteriaList, err := h.Course.Criteria(ctx)
	if err != nil {
		http.Error(w, `{"error":"course upstream unavailable"}`, http.StatusBadGateway)
		return
	}
	criteriaByID := make(map[string]upstream.Criterion, len(criteriaList))
	for _, c := range criteriaList {
		criteriaByID[c.ID] = c
	}

	lessons, err := h.Course.Lessons(ctx, course.ID)
	if err != nil {
		http.Error(w, `{"error":"course upstream unavailable"}`, http.StatusBadGateway)
		return
	}
	sort.SliceStable(lessons, func(i, j int) bool { return lessons[i].SortOrder < lessons[j].SortOrder })

	scenesByLesson := make(map[string][]upstream.Scene, len(lessons))
	usedCriteria := make(map[string]upstream.Criterion)
	for _, l := range lessons {
		scenes, err := h.Course.Scenes(ctx, l.ID)
		if err != nil {
			http.Error(w, `{"error":"course upstream unavailable"}`, http.StatusBadGateway)
			return
		}
		sort.SliceStable(scenes, func(i, j int) bool { return scenes[i].ID < scenes[j].ID })
		scenesByLesson[l.ID] = scenes
		for _, sc := range scenes {
			for _, id := range sc.Criteria {
				if c, ok := criteriaByID[id]; ok {
					usedCriteria[id] = c
				}
			}
		}
		for _, id := range l.Criteria {
			if c, ok := criteriaByID[id]; ok {
				usedCriteria[id] = c
			}
		}
	}

	writeJSON(w, http.StatusOK, player.Assemble(course, lessons, scenesByLesson, usedCriteria))
}
