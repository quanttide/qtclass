use agent_skills_rs::{install_skill, register_embedded_skill, InstallConfig, Skill};
use clap::{Parser, Subcommand};
use std::path::PathBuf;

mod core;

use core::exit;

#[derive(Parser)]
#[command(name = "qtclass", about = "量潮课堂命令行工具", version)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// 内置 agent skills 管理（编译期内嵌，安装到 .agents/skills）
    Skills {
        #[command(subcommand)]
        action: SkillsAction,
    },
}

#[derive(Subcommand)]
enum SkillsAction {
    /// 列出内置 skills（名称与描述）
    List,
    /// 安装内置 skills 到 .agents/skills
    Install {
        /// 只安装指定名称的 skill（缺省安装全部）
        #[arg(long)]
        skill: Option<String>,
        /// 安装目标目录（缺省为当前目录）
        #[arg(long)]
        dir: Option<PathBuf>,
    },
}

/// 内置 skills 清单：目录名与 SKILL.md frontmatter 的 name 一致，均为 qtclass- 前缀。
const SKILLS: &[(&str, &str)] = &[(
    "qtclass-crowd-task-clarify",
    include_str!("../skills/qtclass-crowd-task-clarify/SKILL.md"),
)];

/// 命令错误：消息 + 退出码（语义单点定义在 core::exit，命令不自带字面量）。
struct CmdError {
    message: String,
    code: i32,
}

impl CmdError {
    fn usage(message: String) -> Self {
        Self {
            message,
            code: exit::USAGE,
        }
    }

    fn not_found(message: String) -> Self {
        Self {
            message,
            code: exit::NOT_FOUND,
        }
    }
}

fn embedded_skills() -> Result<Vec<Skill>, CmdError> {
    SKILLS
        .iter()
        .map(|(dir, content)| {
            let skill = register_embedded_skill(content, &[])
                .map_err(|e| CmdError::usage(format!("内置 skill {} 解析失败: {}", dir, e)))?;
            if skill.name != *dir {
                return Err(CmdError::usage(format!(
                    "内置 skill 目录名 {} 与 frontmatter name {} 不一致",
                    dir, skill.name
                )));
            }
            Ok(skill)
        })
        .collect()
}

fn skills_list() -> Result<(), CmdError> {
    for skill in embedded_skills()? {
        println!("{}  {}", skill.name, skill.description);
    }
    Ok(())
}

fn skills_install(only: Option<String>, dir: Option<PathBuf>) -> Result<(), CmdError> {
    let skills = embedded_skills()?;
    let selected: Vec<&Skill> = match &only {
        Some(name) => {
            let matched: Vec<&Skill> = skills.iter().filter(|s| &s.name == name).collect();
            if matched.is_empty() {
                return Err(CmdError::not_found(format!(
                    "未找到内置 skill: {}（可用: {}）",
                    name,
                    skills
                        .iter()
                        .map(|s| s.name.as_str())
                        .collect::<Vec<_>>()
                        .join(", ")
                )));
            }
            matched
        }
        None => skills.iter().collect(),
    };

    let base = match dir {
        Some(d) => d,
        None => std::env::current_dir()
            .map_err(|e| CmdError::usage(format!("读取当前目录失败: {}", e)))?,
    };
    let canonical_dir = base.join(".agents/skills");
    let config = InstallConfig::new(canonical_dir);

    for skill in selected {
        let result = install_skill(skill, &config)
            .map_err(|e| CmdError::usage(format!("安装 {} 失败: {}", skill.name, e)))?;
        println!("✓ {} → {}", skill.name, result.path.display());
    }
    Ok(())
}

fn main() {
    let cli = Cli::parse();
    let result = match cli.command {
        Commands::Skills { action } => match action {
            SkillsAction::List => skills_list(),
            SkillsAction::Install { skill, dir } => skills_install(skill, dir),
        },
    };
    if let Err(e) = result {
        eprintln!("错误: {}", e.message);
        std::process::exit(e.code);
    }
}
