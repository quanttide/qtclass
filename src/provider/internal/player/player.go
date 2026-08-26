// Package player 把课程云内容实体组装为 Studio 播放器契约（course.json 结构）。
// 契约事实源：qtclass studio `lib/services/course_data.dart` 与 `lib/models/segment.dart`。
package player

import (
	"sort"
	"strconv"
	"strings"

	"github.com/quanttide/qtclass-provider/internal/upstream"
)

const defaultSegmentSeconds = 15.0 // 场景无时长字段，原型期统一 15 秒

// PlayerData 播放器契约根结构。
type PlayerData struct {
	Title            string                   `json:"title"`
	Description      string                   `json:"description"`
	Objectives       []string                 `json:"objectives"`
	Segments         map[string]PlayerSegment `json:"segments"`
	PathSteps        []PlayerPathStep         `json:"pathSteps"`
	Interactions     map[string]any           `json:"interactions"`
	InteractionNodes []any                    `json:"interactionNodes"`
}

// PlayerSegment 播放片段：场景按顺序以 next 串联，末段置 action=finish。
type PlayerSegment struct {
	ID         string   `json:"id"`
	SceneKey   string   `json:"sceneKey,omitempty"`
	Duration   float64  `json:"duration"`
	Title      string   `json:"title,omitempty"`
	Caption    string   `json:"caption"`
	Chapter    string   `json:"chapter"`
	PathStepID string   `json:"pathStepId"`
	Criteria   []string `json:"criteria,omitempty"` // 关联验收标准组（完成回写的依据）
	Video      string   `json:"video,omitempty"`
	Next       string   `json:"next,omitempty"`
	Action     string   `json:"action,omitempty"`
}

// PlayerPathStep 侧边栏步骤（label 兼容旧数据 title 字段）。
type PlayerPathStep struct {
	ID        string `json:"id"`
	Label     string `json:"label"`
	Meta      string `json:"meta,omitempty"`
	SegmentID string `json:"segmentId,omitempty"`
}

// Assemble 把一门课的实体组装为播放器数据。
func Assemble(course upstream.Course, lessons []upstream.Lesson, scenesByLesson map[string][]upstream.Scene, criteriaByID map[string]upstream.Criterion) PlayerData {
	data := PlayerData{
		Title:            course.Name,
		Description:      course.Description,
		Objectives:       []string{},
		Segments:         map[string]PlayerSegment{},
		PathSteps:        []PlayerPathStep{},
		Interactions:     map[string]any{},
		InteractionNodes: []any{},
	}

	sort.SliceStable(lessons, func(i, j int) bool { return lessons[i].SortOrder < lessons[j].SortOrder })

	for _, lesson := range lessons {
		scenes := scenesByLesson[lesson.ID]
		sort.SliceStable(scenes, func(i, j int) bool { return NumericIDLess(scenes[i].ID, scenes[j].ID) })
		firstSceneID := ""
		if len(scenes) > 0 {
			firstSceneID = scenes[0].ID
		}
		data.PathSteps = append(data.PathSteps, PlayerPathStep{
			ID:        lesson.ID,
			Label:     lesson.Title,
			SegmentID: firstSceneID,
		})

		for i, sc := range scenes {
			seg := PlayerSegment{
				ID:         sc.ID,
				SceneKey:   sc.Slug,
				Duration:   defaultSegmentSeconds,
				Title:      sc.Title,
				Caption:    sc.VerifyTip,
				Chapter:    lesson.Title,
				PathStepID: lesson.ID,
				Criteria:   criteria(sc.Criteria, criteriaByID),
				Video:      sc.VideoURL,
			}
			if i < len(scenes)-1 {
				seg.Next = scenes[i+1].ID
			} else {
				seg.Action = "finish"
			}
			data.Segments[sc.ID] = seg
		}
	}
	return data
}

// criteria 去重保序地合并场景与所属课时的标准引用。
func criteria(sceneCriteria []string, byID map[string]upstream.Criterion) []string {
	if len(sceneCriteria) == 0 {
		return nil
	}
	out := make([]string, 0, len(sceneCriteria))
	for _, id := range sceneCriteria {
		if _, ok := byID[id]; ok && !contains(out, id) {
			out = append(out, id)
		}
	}
	if len(out) == 0 {
		return nil
	}
	return out
}

func contains(s []string, v string) bool {
	for _, x := range s {
		if x == v {
			return true
		}
	}
	return false
}

// SortLessonsBySortOrder 按 sortOrder 稳定排序。
func SortLessonsBySortOrder(lessons []upstream.Lesson) []upstream.Lesson {
	sort.SliceStable(lessons, func(i, j int) bool { return lessons[i].SortOrder < lessons[j].SortOrder })
	return lessons
}

// NumericIDLess 按 ID 数字后缀比较（如 scen-2 < scen-10）。
func NumericIDLess(a, b string) bool {
	ai, aok := numericSuffix(a)
	bi, bok := numericSuffix(b)
	if aok && bok {
		return ai < bi
	}
	return strings.Compare(a, b) < 0
}

func numericSuffix(id string) (int, bool) {
	idx := strings.LastIndex(id, "-")
	if idx < 0 || idx == len(id)-1 {
		return 0, false
	}
	n, err := strconv.Atoi(id[idx+1:])
	if err != nil {
		return 0, false
	}
	return n, true
}
