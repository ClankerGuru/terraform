# Go

General-purpose Go development workspace.

## Image

[`ghcr.io/clankerguru/devcontainer:go-latest`](https://github.com/ClankerGuru/devcontainer/pkgs/container/devcontainer)

Built from [`ClankerGuru/devcontainer`](https://github.com/ClankerGuru/devcontainer) — `go/Dockerfile`.

Rebuilt weekly (Mondays 06:00 UTC) and on every release tag.

## Languages & SDKs

| Tool | Version | Source |
|------|---------|--------|
| Go | 1.24.2 | direct download |
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

| Agent | Package | Default |
|-------|---------|---------|
| Claude Code | `@anthropic-ai/claude-code` | off |
| GitHub Copilot CLI | `@github/copilot` | off |
| Codex CLI | `@openai/codex` | off |
| OpenCode | `opencode-ai` | off |

## IDEs (optional)

Toggle at workspace creation.

| IDE | Access | Default |
|-----|--------|---------|
| JetBrains Gateway | GoLand | on |
| code-server | VS Code in the browser | on |
| VS Code Desktop | Remote SSH from local VS Code | off |

## Persistent Volumes

Data survives workspace restarts and rebuilds:

| Path | Volume | Purpose |
|------|--------|---------|
| `/workspace` | `coder-{owner}-{name}-workspace` | Project files, cloned repos |

## Networking

The workspace container joins the Coder Docker network (`clanker-zone-coder-r7qc1n`) and reaches the Coder server via `http://coder:7080` internally.

DNS is set to `1.1.1.1` (Cloudflare) for external resolution.

## Updating This Template

Templates live in [`ClankerGuru/terraform`](https://github.com/ClankerGuru/terraform) under `go-workspace/`.

To update:

```bash
# Edit the template
vim go-workspace/main.tf

# Push to Coder
coder templates push go-workspace --directory ./go-workspace

# Existing workspaces show an "Update" button in the dashboard
```

Template metadata (name, description, icon):

```bash
coder templates edit go-workspace \
  --display-name "Go" \
  --description "Your description" \
  --icon "/icon/go.svg"
```

## Creating a Workspace

From the dashboard: Templates > Go > Create Workspace.

From the CLI:

```bash
# With all defaults
coder create dev --template go-workspace --use-parameter-defaults

# Interactive (choose agents and IDEs)
coder create dev --template go-workspace
```

## Connecting

| Method | Command |
|--------|---------|
| SSH | `coder ssh dev` |
| JetBrains Gateway | Open Gateway > Coder > select workspace |
| code-server | Click "code-server" in the dashboard |
| VS Code Desktop | Click "VS Code Desktop" in the dashboard |
