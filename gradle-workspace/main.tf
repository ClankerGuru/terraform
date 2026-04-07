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

data "coder_parameter" "repo" {
  name         = "repo"
  display_name = "Repository"
  description  = "Git repository URL to clone"
  type         = "string"
  default      = "git@github.com:ClankerGuru/wrkx.git"
}

data "coder_parameter" "branch" {
  name         = "branch"
  display_name = "Branch"
  description  = "Branch to checkout after cloning"
  type         = "string"
  default      = "main"
}

data "coder_parameter" "agent_claude" {
  name         = "agent_claude"
  display_name = "Claude Code"
  description  = "Install Claude Code CLI agent"
  type         = "bool"
  default      = true
  icon         = "/icon/anthropic.svg"
}

data "coder_parameter" "agent_copilot" {
  name         = "agent_copilot"
  display_name = "GitHub Copilot CLI"
  description  = "Install GitHub Copilot CLI agent"
  type         = "bool"
  default      = true
  icon         = "/icon/github.svg"
}

data "coder_parameter" "agent_codex" {
  name         = "agent_codex"
  display_name = "Codex CLI"
  description  = "Install OpenAI Codex CLI agent"
  type         = "bool"
  default      = true
  icon         = "/icon/openai.svg"
}

data "coder_parameter" "agent_opencode" {
  name         = "agent_opencode"
  display_name = "OpenCode"
  description  = "Install OpenCode CLI agent"
  type         = "bool"
  default      = true
  icon         = "/icon/terminal.svg"
}

data "coder_parameter" "ide_vscode_desktop" {
  name         = "ide_vscode_desktop"
  display_name = "VS Code Desktop"
  description  = "Enable VS Code Desktop via Remote SSH"
  type         = "bool"
  default      = false
}

data "coder_parameter" "ide_code_server" {
  name         = "ide_code_server"
  display_name = "code-server (browser)"
  description  = "Enable code-server (VS Code in the browser)"
  type         = "bool"
  default      = false
}

resource "coder_agent" "main" {
  os             = "linux"
  arch           = data.coder_provisioner.me.arch
  dir            = "/workspace"
  startup_script = <<-EOT
    # Clone the repo if not already present
    if [ ! -d "/workspace/.git" ]; then
      git clone --branch "${data.coder_parameter.branch.value}" "${data.coder_parameter.repo.value}" /workspace
    fi

    # Source SDKMAN for the agent session
    if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
      . "$HOME/.sdkman/bin/sdkman-init.sh"
    fi

    # Install selected AI agents
    %{if data.coder_parameter.agent_claude.value == "true"}
    bun install -g @anthropic-ai/claude-code
    %{endif}
    %{if data.coder_parameter.agent_copilot.value == "true"}
    gh extension install github/gh-copilot
    %{endif}
    %{if data.coder_parameter.agent_codex.value == "true"}
    bun install -g @openai/codex
    %{endif}
    %{if data.coder_parameter.agent_opencode.value == "true"}
    bun install -g opencode-ai
    %{endif}
  EOT
}

module "jetbrains_gateway" {
  count          = data.coder_workspace.me.start_count
  source         = "registry.coder.com/modules/jetbrains-gateway/coder"
  version        = "1.2.6"
  agent_id       = coder_agent.main.id
  folder         = "/workspace"
  jetbrains_ides = ["IU", "GO", "RR", "WS"]
  default        = "IU"
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

resource "docker_image" "workspace" {
  name = "ghcr.io/clankerguru/devcontainer:gradle-latest"
}

resource "docker_volume" "gradle_cache" {
  name = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-gradle"
}

resource "docker_volume" "workspace_data" {
  name = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}-workspace"
}

resource "docker_container" "workspace" {
  count      = data.coder_workspace.me.start_count
  name       = "coder-${data.coder_workspace_owner.me.name}-${data.coder_workspace.me.name}"
  image      = docker_image.workspace.image_id
  entrypoint = ["sh", "-c", replace(replace(coder_agent.main.init_script, "https://coder.clanker.zone", "http://host.docker.internal:7080"), "/localhost|127\\.0\\.0\\.1/", "host.docker.internal")]

  hostname = data.coder_workspace.me.name
  dns      = ["1.1.1.1"]

  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}",
    "GRADLE_OPTS=-Xmx2g -XX:+UseG1GC",
  ]

  volumes {
    volume_name    = docker_volume.gradle_cache.name
    container_path = "/home/dev/.gradle"
  }

  volumes {
    volume_name    = docker_volume.workspace_data.name
    container_path = "/workspace"
  }

  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }
}
}
