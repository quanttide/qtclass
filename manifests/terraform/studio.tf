# studio 客户端发布分发桶（IaC）
#
# 桶 qtclass-studio：命名对齐站点规范 {repo}-{type}（如 qtdata-studio / qtcloud-delib-studio）。
# 差异说明：qtclass 为桌面客户端（Linux bundle 分发），非 Web 静态站点，故不做 website 托管，
# 仅公共读对象桶承载安装包（tar.gz / zip）。
# 部署流水线：.github/workflows/deploy-studio.yml（tag 触发 → flutter build linux → 打包 → ossutil cp）。

resource "alicloud_oss_bucket" "studio" {
  bucket = "qtclass-studio"
}

# 公共读：客户端安装包分发下载；如后续接入 CDN 回源鉴权可改回 private
resource "alicloud_oss_bucket_acl" "studio" {
  bucket = alicloud_oss_bucket.studio.bucket
  acl    = "public-read"
}
