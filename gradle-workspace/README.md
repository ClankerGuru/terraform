# Gradle Workspace

Full-stack development workspace with JVM, Go, Rust, and Android SDK.

## What's included

- **Languages**: Java 17 (JBR), Kotlin 2.3.20, Gradle 9.4.1, Go 1.24.2, Rust (stable)
- **Android**: SDK cmdline-tools, adb, build-tools 35.0.1, platform android-35
- **Editor**: Neovim 0.11.7 + LazyVim, LazyGit, LazySql
- **Tools**: Bun, gh CLI, Starship, gum, glow, vhs, skate, ripgrep, fd, fzf

## AI Agents (optional)

Toggle at workspace creation:

| Agent | Package |
|-------|---------|
| Claude Code | `@anthropic-ai/claude-code` |
| GitHub Copilot CLI | `gh copilot` extension |
| Codex CLI | `@openai/codex` |
| OpenCode | `opencode-ai` |

## IDEs (optional)

| IDE | Access |
|-----|--------|
| JetBrains Gateway | IntelliJ IDEA, GoLand, RustRover, WebStorm |
| VS Code Desktop | Remote SSH |
| code-server | VS Code in the browser |

## Volumes

- `/home/dev/.gradle` — Gradle cache (persists across restarts)
- `/workspace` — Project files (persists across restarts)
