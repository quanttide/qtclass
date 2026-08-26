package handler

import (
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"
)

// learnCompletion 学习云既有完成记录（fixture 用）。
type learnCompletion struct {
	ID          string
	LearnerID   string
	CriterionID string
	Status      string
}

// learnCapture 记录学习云 mock 收到的调用。
type learnCapture struct {
	auth          string
	created       []map[string]any
	putStatusByID map[string]string
}

func decode(r *http.Request, out any) error {
	b, err := io.ReadAll(r.Body)
	if err != nil {
		return err
	}
	return json.Unmarshal(b, out)
}

// mockUpstreams 起两个 httptest 上游：课程云（四资源 fixture）与学习云（完成记录）。
func mockUpstreams(t *testing.T, existing []learnCompletion) (*httptest.Server, *httptest.Server, *learnCapture) {
	t.Helper()
	cap := &learnCapture{putStatusByID: map[string]string{}}

	muxCourse := http.NewServeMux()
	muxCourse.HandleFunc("GET /criteria", func(w http.ResponseWriter, _ *http.Request) {
		w.Write([]byte(`[
			{"id":"cri-1","lessonId":"less-1","title":"会连接 Zed","description":"Zed 已启动"},
			{"id":"cri-2","lessonId":"less-1","title":"提交首个 commit"}
		]`))
	})
	muxCourse.HandleFunc("GET /courses", func(w http.ResponseWriter, _ *http.Request) {
		w.Write([]byte(`[{"id":"prod","name":"生产实习","description":"走进真实业务","status":"published","sortOrder":5}]`))
	})
	muxCourse.HandleFunc("GET /courses/{courseId}/lessons", func(w http.ResponseWriter, r *http.Request) {
		if r.PathValue("courseId") == "prod" {
			w.Write([]byte(`[{"id":"less-1","courseId":"prod","title":"创立故事","sortOrder":1,"status":"published","criteria":["cri-1"]}]`))
			return
		}
		w.WriteHeader(http.StatusNotFound)
	})
	muxCourse.HandleFunc("GET /lessons/{lessonId}/scenes", func(w http.ResponseWriter, r *http.Request) {
		if r.PathValue("lessonId") == "less-1" {
			w.Write([]byte(`[{"id":"scen-1","lessonId":"less-1","title":"开场","slug":"open","videoUrl":"https://v/intro.mp4","verifyTip":"确认 Zed 已启动","criteria":["cri-1"]}]`))
			return
		}
		w.WriteHeader(http.StatusNotFound)
	})

	existingJSON := `[`
	for i, c := range existing {
		if i > 0 {
			existingJSON += ","
		}
		existingJSON += `{"id":"` + c.ID + `","learner_id":"` + c.LearnerID + `","criterion_id":"` + c.CriterionID + `","status":"` + c.Status + `"}`
	}
	existingJSON += `]`

	muxLearn := http.NewServeMux()
	muxLearn.HandleFunc("GET /completions", func(w http.ResponseWriter, r *http.Request) {
		cap.auth = r.Header.Get("Authorization")
		w.Write([]byte(existingJSON))
	})
	muxLearn.HandleFunc("POST /completions", func(w http.ResponseWriter, r *http.Request) {
		cap.auth = r.Header.Get("Authorization")
		var payload map[string]any
		if err := decode(r, &payload); err != nil {
			http.Error(w, "bad json", http.StatusBadRequest)
			return
		}
		cap.created = append(cap.created, payload)
		w.Header().Set("Content-Type", "application/json")
		w.Write([]byte(`{"id":"com-new"}`))
	})
	muxLearn.HandleFunc("PUT /completions/{id}", func(w http.ResponseWriter, r *http.Request) {
		var payload map[string]any
		if err := decode(r, &payload); err != nil {
			http.Error(w, "bad json", http.StatusBadRequest)
			return
		}
		if st, ok := payload["status"].(string); ok {
			cap.putStatusByID[r.PathValue("id")] = st
		}
		w.Write([]byte(`{"ok":true}`))
	})

	cs := httptest.NewServer(muxCourse)
	ls := httptest.NewServer(muxLearn)
	t.Cleanup(cs.Close)
	t.Cleanup(ls.Close)
	return cs, ls, cap
}
