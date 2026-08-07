# qtclass 部署选型（IaC）

对齐 qtcloud-delib 的部署模式（系统级资源由 quanttide-platform 管理），作为 Terraform 基础设施代码的设计依据。

## 部署选型

| 维度 | 选型 | 说明 |
|------|------|------|
| 客户端形态 | 桌面应用（Flutter Linux） | `src/studio`，`flutter build linux --release` 产出 bundle |
| 发布分发 | 阿里云 OSS 桶 `qtclass-studio` | 承载 Linux bundle 安装包（tar.gz），公共读下载 |
| CDN | 预留（按需接入） | 分发量增长后接 CDN 加速，域名/证书按系统级规范配置 |
| 服务端 | **不适用** | qtclass 为纯客户端，无服务端部署（LMS 能力已迁至 qtcloud-learn，其服务端见 qtcloud-learn IaC） |

## 本 IaC 范围

- **应用级**（`qtclass-<env>` 命名）：OSS 发布分发桶 `qtclass-studio`（公共读，`studio.tf`）
- **不含** 服务计算、数据库、API 网关、域名、DNS（客户端无服务端；系统级资源由 quanttide-platform 管理）

## studio 客户端发布

- 基础设施：`terraform apply`（`studio.tf`：桶 + 公共读）
- 构建上传：`.github/workflows/deploy-studio.yml`（推送 tag `studio/*` 触发 → flutter build linux → 打包 → ossutil cp）

## 使用

```sh
terraform init \
  -backend-config="bucket=quanttide-terraform-state" \
  -backend-config="key=qtclass/terraform.tfstate" \
  -backend-config="region=cn-hangzhou"
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```
