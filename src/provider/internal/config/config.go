// Package config 提供集中化环境变量配置。
package config

import "os"

// Config 是服务端全部配置。本服务无独立存储，仅聚合上游。
type Config struct {
	Addr      string // 监听地址，默认 ":8080"
	CourseAPI string // 课程云基址（QTCLASS_COURSE_API_URL）
	LearnAPI  string // 学习云网关基址（QTCLASS_LEARN_API_URL）
}

// Load 从环境变量加载配置，缺失时使用默认值。
func Load() *Config {
	return &Config{
		Addr:      getEnv("LISTEN_ADDR", ":8080"),
		CourseAPI: getEnv("QTCLASS_COURSE_API_URL", "http://127.0.0.1:8081"),
		LearnAPI:  getEnv("QTCLASS_LEARN_API_URL", "http://127.0.0.1:8082"),
	}
}

func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}
