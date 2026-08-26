# ============================================================
# provider（qtclass 学员端集成层）—— 阿里云 FC 3.0 容器部署
# 无独立存储：读请求实时聚合课程云；完成回写透传学习云。
# 上游基址经环境变量注入（QTCLASS_API_BASE_URL，派生 /qtcloud-course 与 /qtcloud-learn），
# 默认指向 API 网关统一接入路径；变更时在 terraform.tfvars 覆盖）。
# ============================================================

# FC 默认角色：允许 FC 服务挂载弹性网卡访问 VPC（应用级）
resource "alicloud_ram_role" "fc" {
  role_name = "${local.app_name_prefix}-fc"
  assume_role_policy_document = jsonencode({
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = ["fc.aliyuncs.com"] }
    }]
    Version = "1"
  })
  description = "Function Compute 默认角色（qtclass）"
}

resource "alicloud_ram_role_policy_attachment" "fc_vpc" {
  policy_name = "AliyunECSNetworkInterfaceManagementAccess"
  policy_type = "System"
  role_name   = alicloud_ram_role.fc.role_name
}

resource "alicloud_fcv3_function" "this" {
  function_name   = local.app_name_prefix
  description     = "qtclass 学员端集成层（播放器组装 + 完成回写代理）"
  runtime         = "custom-container"
  handler         = "index.handler"
  cpu             = 0.5
  memory_size     = var.fc_memory
  disk_size       = 512
  timeout         = var.fc_timeout
  internet_access = true
  role            = alicloud_ram_role.fc.arn

  custom_container_config {
    image = var.image
    port  = 8080
  }

  environment_variables = {
    QTCLASS_API_BASE_URL = var.api_base_url
  }

  tags = {
    project     = var.project
    environment = var.environment
  }
}

resource "alicloud_fcv3_trigger" "http" {
  function_name = alicloud_fcv3_function.this.function_name
  trigger_name  = "http"
  trigger_type  = "http"
  qualifier     = "LATEST"
  trigger_config = jsonencode({
    authType = "anonymous"
    methods  = ["GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS"]
  })
}
