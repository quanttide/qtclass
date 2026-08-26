// Package config 提供集中化环境变量配置。
package config

import (
	"os"
	"strings"
)

// Config 是服务端全部配置。本服务无独立存储，仅聚合上游。
type Config struct {
	Addr       string // 监听地址，默认 ":8080"
	APIBaseURL string // 上游 API 网关基址（QTCLASS_API_BASE_URL），
	// 派生两个上游：课程云 = <base>/qtcloud-course，学习云 = <base>/qtcloud-learn
}

// Load 从环境变量加载配置，缺失时使用默认值。
func Load() *Config {
	return &Config{
		Addr:       getEnv("LISTEN_ADDR", ":8080"),
		APIBaseURL: getEnv("QTCLASS_API_BASE_URL", "https://api.quanttide.com"),
	}
}

// CourseBase 课程云上游基址。
func (c *Config) CourseBase() string { return strings.TrimRight(c.APIBaseURL, "/") + "/qtcloud-course" }

// LearnBase 学习云上游基址。
func (c *Config) LearnBase() string { return strings.TrimRight(c.APIBaseURL, "/") + "/qtcloud-learn" }

func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}
