package player

import (
	"testing"

	"github.com/quanttide/qtclass-provider/internal/upstream"
)

func TestAssemble_ChainingAndFinish(t *testing.T) {
	course := upstream.Course{ID: "prod", Name: "生产实习", Status: "published"}
	lessons := []upstream.Lesson{
		{ID: "less-2", Title: "第二课时", SortOrder: 2},
		{ID: "less-1", Title: "第一课时", SortOrder: 1},
	}
	scenesByLesson := map[string][]upstream.Scene{
		"less-1": {
			{ID: "scen-2", LessonID: "less-1", Title: "开场", Slug: "open", VideoURL: "https://v/a.mp4", VerifyTip: "确认终端可见"},
			{ID: "scen-10", LessonID: "less-1", Title: "结尾", Slug: "end"},
		},
		"less-2": {
			{ID: "scen-3", LessonID: "less-2", Title: "任务"},
		},
	}
	criteriaByID := map[string]upstream.Criterion{
		"cri-1": {ID: "cri-1", Title: "会连接 Zed"},
	}

	data := Assemble(course, lessons, scenesByLesson, criteriaByID)

	if data.Title != "生产实习" || len(data.PathSteps) != 2 {
		t.Fatalf("root = %+v steps=%d", data.Title, len(data.PathSteps))
	}
	// 课时顺序由 sortOrder 保证
	if data.PathSteps[0].ID != "less-1" || data.PathSteps[1].ID != "less-2" {
		t.Fatalf("pathSteps order = %+v", data.PathSteps)
	}
	// pathStep 指向首场景
	if data.PathSteps[0].SegmentID != "scen-2" || data.PathSteps[1].SegmentID != "scen-3" {
		t.Fatalf("segmentId = %+v", data.PathSteps)
	}

	// 场景按 ID 数值排序串联（scen-2 → scen-10，末段 finish）
	s2 := data.Segments["scen-2"]
	if s2.Next != "scen-10" || s2.Action != "" {
		t.Fatalf("scen-2 next/action = %q/%q", s2.Next, s2.Action)
	}
	s10 := data.Segments["scen-10"]
	if s10.Action != "finish" || s10.Next != "" {
		t.Fatalf("scen-10 action = %q", s10.Action)
	}
	if s2.Video != "https://v/a.mp4" || s2.Caption != "确认终端可见" || s2.Chapter != "第一课时" {
		t.Fatalf("scen-2 = %+v", s2)
	}

	// 无标准引用的场景不携带 criteria 字段语义（nil）
	if len(data.Segments["scen-3"].Criteria) != 0 {
		t.Fatalf("empty criteria = %v", data.Segments["scen-3"].Criteria)
	}
}

func TestAssemble_CriteriaUnionDedup(t *testing.T) {
	course := upstream.Course{Name: "c"}
	lessons := []upstream.Lesson{{ID: "less-1", Title: "l1", Criteria: []string{"cri-1"}}}
	scenesByLesson := map[string][]upstream.Scene{
		"less-1": {{ID: "scen-1", Criteria: []string{"cri-1", "cri-2"}}},
	}
	criteriaByID := map[string]upstream.Criterion{
		"cri-1": {ID: "cri-1"}, "cri-2": {ID: "cri-2"},
	}
	data := Assemble(course, lessons, scenesByLesson, criteriaByID)
	got := data.Segments["scen-1"].Criteria
	if len(got) != 2 || got[0] != "cri-1" || got[1] != "cri-2" {
		t.Fatalf("criteria = %v, want dedup union [cri-1 cri-2]", got)
	}
}

func TestNumericIDLess(t *testing.T) {
	if !NumericIDLess("scen-2", "scen-10") {
		t.Fatal("lexicographic comparison leaked into numeric ordering")
	}
	if NumericIDLess("scen-10", "scen-2") {
		t.Fatal("numeric ordering inverted")
	}
}
