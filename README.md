# terraform

Coder workspace templates and Dokploy compose files.

## Setup

### Coder CLI

```bash
curl -L https://coder.com/install.sh | sh
coder login https://your-coder-url.com
```

### Dokploy CLI

```bash
npm install -g @dokploy/cli
dokploy authenticate
```

---

## Coder Templates

### Push a template

```bash
coder templates push gradle-workspace --directory ./gradle-workspace
coder templates push infra-workspace --directory ./infra-workspace
```

### Create a workspace

```bash
coder create dev --template gradle-workspace
```

### Available templates

| Template | Image | Purpose |
|----------|-------|---------|
| `gradle-workspace` | `gradle-latest` | Full-stack dev: JVM, Go, Rust, Android SDK, AI agents, JetBrains IDEs |
| `infra-workspace` | `infra-latest` | Infrastructure admin: coder, dokploy, hapi CLIs, Charm tools |

---

## Dokploy Compose Files

### Deploy a compose

In Dokploy UI: create a Compose project, paste the `docker-compose.yml`, set env vars in the Environment tab, deploy.

Or via CLI:

```bash
dokploy app deploy
```

### Available composes

| Compose | Path | Required env vars |
|---------|------|-------------------|
| Coder server | `dokploy/coder/` | `CODER_ACCESS_URL`, `CODER_HTTP_ADDRESS`, `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD` |
| code-server | `dokploy/code-server/` | `PASSWORD`, `TZ` |

### Coder env example

```
CODER_ACCESS_URL=https://coder.yourdomain.com
CODER_HTTP_ADDRESS=0.0.0.0:7080
POSTGRES_DB=coder
POSTGRES_USER=coder
POSTGRES_PASSWORD=changeme
```

### code-server env example

```
PASSWORD=changeme
TZ=America/Los_Angeles
```

code-server domain: add in Dokploy Domains tab, port `8443`, HTTPS enabled.

---

## Structure

```text
terraform/
├── gradle-workspace/       <- Coder dev workspace template
│   └── main.tf
├── infra-workspace/        <- Coder infra workspace template
│   └── main.tf
├── dokploy/
│   ├── coder/              <- Coder server + PostgreSQL
│   │   └── docker-compose.yml
│   └── code-server/        <- Standalone browser IDE
│       └── docker-compose.yml
└── README.md
```

## License

[MIT](LICENSE)
