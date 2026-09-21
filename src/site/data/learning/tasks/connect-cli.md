---
title: 摸底 lark-cli 与 wecom-cli
description: 动手试用企业微信 wecom-cli 与飞书 lark-cli，逐个模块摸清能做什么、不能做什么，写出能力契约文档，沉淀到沟通管理参考资料库。
---

# 摸底 lark-cli 与 wecom-cli

沟通云围绕企业微信和飞书两个平台做沟通管理，两个平台各有一套命令行工具：wecom-cli（企业微信）和 lark-cli（飞书）。要用好它们，前提是知道每个工具能做什么、不能做什么、边界在哪里。这类「能力契约」一旦写清楚，后面做自动化和 AI 智能体时就不会反复踩坑。

参考资料库里已有一份先例，可以直接参照：[wecom-cli/contract.md](https://github.com/quanttide/quanttide-library-of-communication-management/blob/main/wecom-cli/contract.md)。

## 步骤

1. 安装并完成授权：`npm install -g @wecom/cli`，然后 `wecom-cli auth init` 扫码授权；lark-cli 按其文档安装授权
2. 逐个模块试用：通讯录、消息、日程、会议、待办、邮件、微盘、文档、表格等，每个模块记录三件事——能做什么、怎么调用、有什么限制
3. 对 lark-cli 做同样的摸底
4. 把两个工具的同类能力放在一起对比：哪个覆盖全、哪个缺能力、哪些说法不一致
5. 按照已有 contract.md 的格式，为每个模块撰写能力契约文档

## 交付与提交方式

产出提交到量潮沟通管理参考：https://github.com/quanttide/quanttide-library-of-communication-management

1. 在 Issue 中分享你的试用记录与发现：哪些能力可用、哪些受限、两个平台的差异
2. 讨论达成共识后提交 PR，并在 PR 中引用该 Issue
3. PR 通过后关闭 Issue

## 重要提醒

- 契约只写实际验证过的事实，没有亲自测过的能力标注「待验证」
- 涉及真实人名、邮箱、部门名称的内容，提交前先脱敏
- 命令返回中的内部标识（userid、chat_id 之类）不出现在文档里，用可读名称代替
