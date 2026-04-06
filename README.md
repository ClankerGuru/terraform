# terraform

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow)](https://opensource.org/licenses/MIT)

Coder workspace templates and Dokploy compose files for ClankerGuru infrastructure.

## Coder Templates

Templates are pushed to the Coder server via `coder templates push`.

### gradle-workspace

Full-stack development workspace using `ghcr.io/clankerguru/devcontainer:gradle-latest`.

- JVM (Java, Kotlin, Gradle), Go, Rust, Android SDK
- AI agents: Claude Code, GitHub Copilot CLI, Codex CLI, OpenCode (toggleable)
- JetBrains IDEs: IntelliJ IDEA Ultimate, GoLand, RustRover, WebStorm
- Optional: VS Code Desktop, code-server (browser)

```bash
coder templates push gradle-workspace --directory ./gradle-workspace
```

### infra-workspace

Lightweight infrastructure admin workspace using `ghcr.io/clankerguru/devcontainer:infra-latest`.

- coder, dokploy, hapi CLIs
- Charm tools (gum, glow, vhs, skate), LazyGit, LazySql
- code-server for browser access

```bash
coder templates push infra-workspace --directory ./infra-workspace
```

## Dokploy Compose Files

Docker Compose files for services deployed on Dokploy.

### dokploy/coder

Coder server with PostgreSQL. Deploy on Dokploy as a Compose project.

**Required environment variables:**

| Variable | Example |
|----------|---------|
| `CODER_ACCESS_URL` | `https://coder.yourdomain.com` |
| `CODER_HTTP_ADDRESS` | `0.0.0.0:7080` |
| `POSTGRES_DB` | `coder` |
| `POSTGRES_USER` | `coder` |
| `POSTGRES_PASSWORD` | (your password) |

### dokploy/code-server

Standalone code-server (VS Code in browser) using the dev container image. Deploy on Dokploy as a Compose project.

**Required environment variables:**

| Variable | Example |
|----------|---------|
| `PASSWORD` | (your login password) |
| `TZ` | `America/Los_Angeles` |

**Domain:** Add your domain in Dokploy's Domains tab, port `8443`, HTTPS enabled.

## Repository Structure

```text
terraform/
├── gradle-workspace/       <- Coder dev workspace template
│   └── main.tf
├── infra-workspace/        <- Coder infra workspace template
│   └── main.tf
├── dokploy/
│   ├── coder/              <- Coder server compose for Dokploy
│   │   └── docker-compose.yml
│   └── code-server/        <- Standalone code-server compose for Dokploy
│       └── docker-compose.yml
└── README.md
```

## Updating Templates

1. Edit the `.tf` file
2. Push to Coder:
   ```bash
   coder templates push <name> --directory ./<name>
   ```
3. Existing workspaces show an "Update" prompt in the dashboard

## License

[MIT](LICENSE)
