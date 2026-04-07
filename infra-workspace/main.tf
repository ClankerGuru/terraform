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

resource "coder_agent" "main" {
  os             = "linux"
  arch           = data.coder_provisioner.me.arch
  dir            = "/workspace"
  startup_script = <<-EOT
    echo "Infra workspace ready"
  EOT
}

module "code_server" {
  count    = data.coder_workspace.me.start_count
  source   = "registry.coder.com/coder/code-server/coder"
  version  = "1.4.4"
  agent_id = coder_agent.main.id
  folder   = "/workspace"
}

resource "docker_image" "workspace" {
  name = "ghcr.io/clankerguru/devcontainer:infra-latest"
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

  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}",
    "GRADLE_OPTS=-Xmx2g -XX:+UseG1GC",
  ]

  networks_advanced {
    name = "clanker-zone-coder-r7qc1n"
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
