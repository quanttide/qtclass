# AGENTS.md - studio

## 版本发布

### 版本号

- pubspec.yaml 中 `version` 必须与 git tag 一致（tag 为 `studio/vX.Y.Z`，pubspec 为 `X.Y.Z`）
- 发布前先更新 `src/studio/CHANGELOG.md`，提交推送后再打 tag

### CHANGELOG

- `src/studio/CHANGELOG.md` 记录本子包的所有版本
- 根目录 `CHANGELOG.md` 只记录主版本（v1.0.0+），v0.x 阶段不记细节
- Release notes 从子包 CHANGELOG 提取，一行一条变更

### 子模块

- studio 是 qtclass 仓库内的目录，发布 tag 和 Release 在 qtclass 仓库操作
- 发布后主仓库（quanttide-platform）更新子模块引用
