# studio 客户端发布分发桶（IaC）
#
# 桶 qtclass-studio：命名对齐站点规范 {repo}-{type}（如 qtdata-studio / qtcloud-delib-studio）。
# 产物：Linux bundle（tar.gz）与 Flutter Web 版（index.html + flutter_bootstrap.js）。
# 静态网站托管：Web 版作为默认首页（class.quanttide.com 根路径），Linux 包位于 /studio/ 目录。
# 部署流水线：.github/workflows/deploy-studio.yml（tag 触发 → flutter build → ossutil cp → 刷新 CDN）。

# qtclass-studio 桶为历史手动创建，未在本状态中——用 import 块纳管。
# 首次 apply 完成纳管后此块即为无操作；删除桶重建时需同步移除。
import {
  to = alicloud_oss_bucket.studio
  id = "qtclass-studio"
}

resource "alicloud_oss_bucket" "studio" {
  bucket = "qtclass-studio"

  # 注意：2023 后新桶默认开启「阻止公共访问」，会使 public-read 失效（AccessDenied）。
  # 该参数当前 alicloud provider 版本不支持在 bucket 资源内声明，桶已按私有创建并在
  # 手动部署时配置过公共访问豁免（见 README）；如需重建此桶，先在此补回参数或用
  # alicloud_oss_bucket_public_access_block 单独声明。

  # 静态网站托管（Web 版入口 index.html）
  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}

# 公共读：客户端与安装包分发下载；如后续接入 CDN 回源鉴权可改回 private
resource "alicloud_oss_bucket_acl" "studio" {
  bucket = alicloud_oss_bucket.studio.bucket
  acl    = "public-read"
}
