# Infra

Infrastructure admin workspace with CLIs and Charm tools.

## Image

[`ghcr.io/clankerguru/devcontainer:infra-latest`](https://github.com/ClankerGuru/devcontainer/pkgs/container/devcontainer)

Built from [`ClankerGuru/devcontainer`](https://github.com/ClankerGuru/devcontainer) — `infra/Dockerfile`.

Rebuilt weekly (Mondays 06:00 UTC) and on every release tag.

## CLIs

| CLI | Purpose |
|-----|---------|
| `coder` | Manage Coder workspaces and templates |
| `dokploy` | Manage Dokploy deployments |
| `hapi` | Manage Hostinger VPS |
| `gh` | GitHub CLI |

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
| zsh + tmux | Shell + multiplexer |
| ripgrep, fd, fzf | Search tools |
| GPG, SSH | Security |
| Bun | Runtime for AI agent installation |

## AI Agents (optional)

Toggle at workspace creation. **All default to off** — enable only what you need.

| Agent | Package | Default |
|-------|---------|---------|
| Claude Code | `@anthropic-ai/claude-code` | off |
| GitHub Copilot CLI | `@github/copilot` | off |
| Codex CLI | `@openai/codex` | off |
| OpenCode | `opencode-ai` | off |

## IDE

code-server (VS Code in the browser) is always enabled. No JetBrains, no VS Code Desktop.

## Persistent Volume

| Path | Volume | Purpose |
|------|--------|---------|
| `/workspace` | `coder-{owner}-{name}-workspace` | Working directory |

## Use Cases

- Managing Dokploy deployments and services
- Pushing Coder templates
- Managing Hostinger VPS (start, stop, rebuild)
- Reviewing repos with LazyGit
- Reading documentation with Glow
- Recording terminal sessions with VHS
- Running Gum-powered automation scripts

## Networking

Same as the Kotlin template — joins the Coder Docker network and reaches the server via `http://coder:7080` internally.

## Updating This Template

Templates live in [`ClankerGuru/terraform`](https://github.com/ClankerGuru/terraform) under `infra-workspace/`.

```bash
# Edit and push
vim infra-workspace/main.tf
coder templates push infra-workspace --directory ./infra-workspace

# Update metadata
coder templates edit infra-workspace \
  --display-name "Infra" \
  --description "Your description" \
  --icon "/icon/docker.svg"
```

## Creating a Workspace

```bash
# No agents (default)
coder create ops --template infra-workspace --use-parameter-defaults

# With Claude Code
coder create ops --template infra-workspace --parameter agent_claude=true
```

## Connecting

| Method | Command |
|--------|---------|
| SSH | `coder ssh ops` |
| code-server | Click "code-server" in the dashboard |
