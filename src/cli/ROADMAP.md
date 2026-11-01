# ROADMAP — qtclass-cli

> 定位：**骨架**。命令面未定，有真实命令再长。三端分工总纲见仓库根 [ROADMAP.md](../../ROADMAP.md)。

## 现状

Rust 骨架（`qtclass-cli`，二进制 `qtclass`），无命令、无依赖。

## 原则

不为预留而造命令。当 qtclass 出现跨 scope 或重复性的真实操作（发布、部署、数据修复）时先走脚本，第二处复用出现再立命令，模式对齐 [qtcloud-cli](../../../qtcloud/src/cli/)（内置 skills 随二进制分发 + 发布链路）。

### 达成标志

首个真实命令立项，本文件从"无规划"改为命令清单。
