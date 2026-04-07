terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "~> 2.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}
provider "coder" {}

data "coder_provisioner" "me" {}
data "coder_workspace" "me" {}
data "coder_workspace_owner" "me" {}

# --- AI Agents ---

data "coder_parameter" "agent_claude" {
  name         = "agent_claude"
  display_name = "Claude Code"
  description  = "Install Claude Code CLI"
  type         = "bool"
  default      = false
  icon         = "/icon/claude.svg"
}

data "coder_parameter" "agent_copilot" {
  name         = "agent_copilot"
  display_name = "GitHub Copilot CLI"
  description  = "Install GitHub Copilot CLI"
  type         = "bool"
  default      = false
  icon         = "/icon/github-copilot.svg"
}

data "coder_parameter" "agent_codex" {
  name         = "agent_codex"
  display_name = "Codex CLI"
  description  = "Install OpenAI Codex CLI"
  type         = "bool"
  default      = false
  icon         = "/icon/openai-codex.svg"
}

data "coder_parameter" "agent_opencode" {
  name         = "agent_opencode"
  display_name = "OpenCode"
  description  = "Install OpenCode CLI"
  type         = "bool"
  default      = false
  icon         = "/icon/terminal.svg"
}

# --- IDEs ---

data "coder_parameter" "ide_jetbrains" {
  name         = "ide_jetbrains"
  display_name = "JetBrains Gateway"
  description  = "Enable JetBrains IDEs (GoLand)"
  type         = "bool"
  default      = true
  icon         = "/icon/jetbrains.svg"
}

data "coder_parameter" "ide_vscode_desktop" {
  name         = "ide_vscode_desktop"
  display_name = "VS Code Desktop"
  description  = "Enable VS Code Desktop via Remote SSH"
  type         = "bool"
  default      = false
  icon         = "/icon/code.svg"
}

data "coder_parameter" "ide_code_server" {
  name         = "ide_code_server"
  display_name = "code-server"
  description  = "Enable code-server (VS Code in the browser)"
  type         = "bool"
  default      = true
  icon         = "/icon/code.svg"
}

# --- Agent ---

resource "coder_agent" "main" {
  os             = "linux"
  arch           = data.coder_provisioner.me.arch
  dir            = "/workspace"
  startup_script = <<-EOT
    # Source shell config if present
    if [ -f "$HOME/.bashrc" ]; then
      . "$HOME/.bashrc"
    fi

    # Install selected AI agents
    %{if data.coder_parameter.agent_claude.value == "true"}
    bun install -g @anthropic-ai/claude-code
    %{endif}
    %{if data.coder_parameter.agent_copilot.value == "true"}
    bun install -g @github/copilot
    %{endif}
    %{if data.coder_parameter.agent_codex.value == "true"}
    bun install -g @openai/codex
    %{endif}
    %{if data.coder_parameter.agent_opencode.value == "true"}
    bun install -g opencode-ai
    %{endif}
  EOT
}

# --- IDE Modules ---

module "jetbrains_gateway" {
  count          = data.coder_parameter.ide_jetbrains.value == "true" ? data.coder_workspace.me.start_count : 0
  source         = "registry.coder.com/modules/jetbrains-gateway/coder"
  version        = "1.2.6"
  agent_id       = coder_agent.main.id
  folder         = "/workspace"
  jetbrains_ides = ["GO"]
  default        = "GO"
  latest         = true
}

module "vscode_desktop" {
  count    = data.coder_parameter.ide_vscode_desktop.value == "true" ? data.coder_workspace.me.start_count : 0
  source   = "registry.coder.com/coder/vscode-desktop/coder"
  version  = "1.2.1"
  agent_id = coder_agent.main.id
  folder   = "/workspace"
}

module "code_server" {
  count    = data.coder_parameter.ide_code_server.value == "true" ? data.coder_workspace.me.start_count : 0
  source   = "registry.coder.com/coder/code-server/coder"
  version  = "1.4.4"
  agent_id = coder_agent.main.id
  folder   = "/workspace"
}

# --- Infrastructure ---

resource "docker_image" "workspace" {
  name = "ghcr.io/clankerguru/devcontainer:go-latest"
}

resource "docker_volume" "workspace_data" {
  name = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-workspace"
}

resource "docker_container" "workspace" {
  count      = data.coder_workspace.me.start_count
  name       = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
  image      = docker_image.workspace.image_id
  entrypoint = ["sh", "-c", replace(coder_agent.main.init_script, "https://coder.clanker.zone", "http://coder:7080")]

  hostname = data.coder_workspace.me.name
  dns      = ["1.1.1.1"]

  networks_advanced {
    name = "clanker-zone-coder-r7qc1n"
  }

  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}",
  ]

  volumes {
    volume_name    = docker_volume.workspace_data.name
    container_path = "/workspace"
  }

  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }
}
