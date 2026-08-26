output "studio_bucket" {
  description = "studio 客户端发布分发桶（部署产物见 .github/workflows/deploy-studio.yml）"
  value       = alicloud_oss_bucket.studio.bucket
}

output "fc_function_name" {
  description = "函数计算函数名"
  value       = alicloud_fcv3_function.this.function_name
}

output "fc_http_url" {
  description = "FC HTTP 触发器公网地址（API 网关接入前的直连入口）"
  value       = try(alicloud_fcv3_trigger.http.http_trigger[0].url_internet, "尚未创建")
}
