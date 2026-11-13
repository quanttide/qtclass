//! 核心层：跨命令共享的常量与类型。域依赖 core，core 不依赖域。

// exit 四码是冻结的 API 面，未被当前命令消费的码（OK / FINDINGS）不视为死代码，
// 保持与 qtfounder 同文件字节一致，不为 lint 改冻结文件。
#[allow(dead_code)]
pub mod exit;
