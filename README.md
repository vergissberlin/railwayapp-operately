# Operately for railway.app

![Template Header](./template-header.svg)

Deploy Operately on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/REPLACE_WITH_RAILWAY_TEMPLATE_CODE?referralCode=2_sIT9&utm_medium=integration&utm_source=template&utm_campaign=generic)

# Deploy and Host Operately on Railway

Operately is an open-source goal, project, and OKR tracking tool that replaces status-update
meetings with structured check-ins. This template runs the official `operately/operately`
Docker image on Railway, backed by a separate Postgres service for data storage.

## About Hosting Operately

Hosting Operately on Railway means running its Elixir/Phoenix release container next to a
managed Postgres instance, with Railway generating the public domain, terminating TLS, and
running the database migration automatically via `preDeployCommand` before every deploy. There
is no server to patch and no reverse proxy to configure by hand.

## Why Deploy Operately on Railway

* No server provisioning — Railway builds and runs the container from the pinned upstream image
* Postgres attaches as a managed Railway service instead of a self-hosted database to babysit
* TLS and the public domain are handled at Railway's edge, so `OPERATELY_HOST` only ever needs
  the bare hostname
* Database migrations run automatically on every deploy via `preDeployCommand`, no manual SSH step
* Renovate keeps the pinned image tag current without floating on `latest`

## Common Use Cases

* Replacing weekly status-update meetings with asynchronous written check-ins
* Tracking OKRs and project goals with automatic progress roll-ups across a company
* Giving leadership a single, always-current view of who owns what and how it is progressing

## Dependencies for Operately

* **Image**: `operately/operately:1.8.0` (official upstream image, pinned tag)
* **Database**: PostgreSQL, provisioned as a separate Railway service and wired in via the
  `DATABASE_URL` reference variable — there is no SQLite fallback
* **Volume**: a Railway volume mounted at `/media` for uploaded files
* **License note**: Operately's core is Apache-2.0; a separate proprietary license covers its
  `ee/` (Enterprise Edition) subtree. This template only references the published Docker image,
  it does not build or redistribute the source.

## ✨ Features

* Goals, projects, and check-ins for teams, replacing status-update meetings
* OKR-style progress tracking with automatic roll-ups across projects
* Company-wide visibility into who owns what and how it is progressing

## 🚀 Quick Start

1. Click "Deploy on Railway"
2. Add a Postgres service to the project and reference it as `DATABASE_URL` (see below)
3. Set the remaining environment variables listed below
4. Attach a volume at `/media` before sending production traffic
5. Wait for the build — `preDeployCommand` creates the database and runs migrations
   automatically — then open the generated URL

## ⚙️ Configuration

### Environment variables

```bash
DATABASE_URL=${{Postgres.DATABASE_URL}}   # Reference variable to a separate Railway Postgres service (Ecto connection string)
SECRET_KEY_BASE=replace-with-strong-random-value   # Set as a generated secret in the Railway dashboard; signs/encrypts cookies
OPERATELY_BLOB_TOKEN_SECRET_KEY=replace-with-strong-random-value   # Set as a generated secret; signs file/blob URLs, required for uploads to work
SYSTEM_SETTINGS_ENCRYPTION_KEYS=replace-with-strong-random-value   # Set as a generated secret; encrypts stored system settings
OPERATELY_HOST=${{RAILWAY_PUBLIC_DOMAIN}}   # Bare hostname only, no scheme or port
OPERATELY_URL_SCHEME=https   # Railway always terminates TLS at the edge
ALLOW_LOGIN_WITH_EMAIL=yes   # Without this and without Google OAuth configured, nobody can log in
ALLOW_SIGNUP_WITH_EMAIL=yes   # Allows the first account to be created without SMTP/Google OAuth
```

Set real credentials as Railway variables, never in a file inside this repository.

### Optional

* `PORT`: HTTP port Operately binds to (default: `4000`). Railway sets this for you;
  leave it alone unless you also change the domain's target port.

## 💾 Persistence

`railway.toml` declares `requiredMountPath = "/media"`. Attach a Railway volume to that
path before production traffic, otherwise all data is lost on every redeploy.

## 🐳 Local Development

```bash
git clone https://github.com/vergissberlin/railwayapp-operately.git
cd railwayapp-operately
cp .env.example .env
docker compose up -d
docker compose exec operately /opt/operately/bin/create_db
docker compose exec operately /opt/operately/bin/migrate
```

`preDeployCommand` in `railway.toml` only runs on Railway, so the two release commands above
have to be run by hand for local Docker Compose. Then open http://localhost:4000.

## 🪲 Bug Reporting

Found a bug? [Create an issue](https://github.com/vergissberlin/railwayapp-operately/issues/new) or open a pull request with a fix.

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## 📝 License

MIT — see [LICENSE](LICENSE).

## 🔒 Security

* All credentials are supplied as environment variables, never committed
* Railway terminates TLS for the generated domain
* Renovate keeps the pinned upstream image up to date

## Railway runtime defaults

`railway.toml` ships these defaults:

* Healthcheck path: `/health`
* Restart policy: `ON_FAILURE` with up to 10 retries
* Dockerfile-based build
* `preDeployCommand`: `/opt/operately/bin/create_db` followed by `/opt/operately/bin/migrate`,
  the same two release commands the official single-host installer runs

Operately listens on `$PORT` directly, so no start command or entrypoint wrapper is configured.
`CERT_DOMAIN`/`CERT_AUTO_RENEW`/`CERT_EMAILS`/`CERT_DB_DIR` are deliberately left unset — those
drive Operately's own Let's Encrypt integration for self-managed hosts, which is redundant and
potentially conflicting with Railway's edge TLS.

## 📚 Resources

* [Operately documentation](https://github.com/operately/operately/blob/main/docs/installation/single-host.md)
* [Railway documentation](https://docs.railway.app/)
* [Template updates](https://docs.railway.com/reference/templates#updatable-templates)

<!-- footer -->
