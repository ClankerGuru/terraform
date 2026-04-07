# Kotlin

Full-stack development workspace for JVM, Go, Rust, and Android.

## Image

[`ghcr.io/clankerguru/devcontainer:gradle-latest`](https://github.com/ClankerGuru/devcontainer/pkgs/container/devcontainer)

Built from [`ClankerGuru/devcontainer`](https://github.com/ClankerGuru/devcontainer) — `jvm/Dockerfile`.

Rebuilt weekly (Mondays 06:00 UTC) and on every release tag.

## Languages & SDKs

| Tool | Version | Source |
|------|---------|--------|
| Java | JetBrains Runtime 17.0.14 | SDKMAN |
| Kotlin | 2.3.20 | SDKMAN |
| Gradle | 9.4.1 | SDKMAN |
| Go | 1.24.2 | direct download |
| Rust | stable | rustup |
| Android SDK | cmdline-tools, adb, build-tools 35.0.1, android-35 | sdkmanager |
| Bun | latest | curl installer |

## Tools

| Tool | Purpose |
|------|---------|
| Neovim 0.11.7 + LazyVim | Terminal editor |
| LazyGit | Git TUI |
| LazySql | Database TUI |
| gum | Interactive shell scripts |
| glow | Markdown reader |
| vhs | Terminal recorder |
| skate | Key-value store |
| Starship | Shell prompt |
| gh | GitHub CLI |
| ripgrep, fd, fzf | Search tools |
| GPG, SSH | Security |

## AI Agents (optional)

Toggle at workspace creation. Installed at runtime via `bun install -g`.

| Agent | Icon | Package | Default |
|-------|------|---------|---------|
| Claude Code | ![claude](/icon/claude.svg) | `@anthropic-ai/claude-code` | on |
| GitHub Copilot CLI | ![copilot](/icon/github-copilot.svg) | `gh copilot` extension | on |
| Codex CLI | ![codex](/icon/openai-codex.svg) | `@openai/codex` | on |
| OpenCode | ![opencode](/icon/terminal.svg) | `opencode-ai` | on |

## IDEs (optional)

Toggle at workspace creation.

| IDE | Access | Default |
|-----|--------|---------|
| JetBrains Gateway | IntelliJ IDEA Ultimate, GoLand, RustRover, WebStorm | on |
| code-server | VS Code in the browser | on |
| VS Code Desktop | Remote SSH from local VS Code | off |

## Persistent Volumes

Data survives workspace restarts and rebuilds:

| Path | Volume | Purpose |
|------|--------|---------|
| `/home/dev/.gradle` | `coder-{owner}-{name}-gradle` | Gradle cache, downloaded dependencies |
| `/workspace` | `coder-{owner}-{name}-workspace` | Project files, cloned repos |

## Networking

The workspace container joins the Coder Docker network (`clanker-zone-coder-r7qc1n`) and reaches the Coder server via `http://coder:7080` internally.

DNS is set to `1.1.1.1` (Cloudflare) for external resolution.

## Updating This Template

Templates live in [`ClankerGuru/terraform`](https://github.com/ClankerGuru/terraform) under `gradle-workspace/`.

To update:

```bash
# Edit the template
vim gradle-workspace/main.tf

# Push to Coder
coder templates push gradle-workspace --directory ./gradle-workspace

# Existing workspaces show an "Update" button in the dashboard
```

Template metadata (name, description, icon):

```bash
coder templates edit gradle-workspace \
  --display-name "Kotlin" \
  --description "Your description" \
  --icon "/icon/kotlin.svg"
```

## Creating a Workspace

From the dashboard: Templates > Kotlin > Create Workspace.

From the CLI:

```bash
# With all defaults
coder create dev --template gradle-workspace --use-parameter-defaults

# Interactive (choose agents and IDEs)
coder create dev --template gradle-workspace
```

## Connecting

| Method | Command |
|--------|---------|
| SSH | `coder ssh dev` |
| JetBrains Gateway | Open Gateway > Coder > select workspace |
| code-server | Click "code-server" in the dashboard |
| VS Code Desktop | Click "VS Code Desktop" in the dashboard |
