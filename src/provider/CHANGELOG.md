# CHANGELOG

## [0.1.0-alpha.2] - 2026-08-28

### Added

- FC 部署管道：deploy-provider 工作流（质量门禁前置 → ACR 镜像构建 → Terraform Apply）+ manifests/terraform 统一基础设施栈新增 FC 资源（函数、HTTP 触发器、上游基址注入）——与 site/studio 静态托管同栈管理
- 移除独立 test-provider.yml——质量门禁并入部署工作流作为前置 job

## [0.1.0-alpha.1] - 2026-08-28

### Added

- 服务骨架：Go 标准库 + `/healthz`，FC 部署管道待配
- 播放器数据组装：聚合课程云 Course/Lesson/Scene/Criterion 四资源，输出 Studio 契约（segments 按 ID 数值排序串联、末段 finish、pathSteps 定位课时入口片段；随路径下发 criteria 关联组）
- 课程目录契约：`GET /courses` 输出 Studio course_service 形态
- 完成回写代理：`POST /completions` 透传认证至学习云；criterion_id 白名单校验 + learner × criterion 幂等（已有记录 PUT 翻状态）
- 质量门禁 CI（vet + 全量测试）
