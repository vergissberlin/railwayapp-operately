# Operately for railway.app

![Template Header](./template-header.svg)

Deploy Operately on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/operately?referralCode=2_sIT9&utm_medium=integration&utm_source=template&utm_campaign=generic)

# Deploy and Host Operately on Railway

Operately is an open-source goal, project, and OKR tracking tool that replaces status-update
meetings with structured check-ins. This template runs the official `operately/operately`
Docker image on Railway, backed by a separate Postgres service for data storage.

## About Hosting Operately

Hosting Operately on Railway means running its Elixir/Phoenix release container next to a
managed Postgres instance, with Railway generating the domain, terminating TLS, and running
the database migration automatically before every deploy — no server to patch, no reverse
proxy to configure by hand.

## Why Deploy Operately on Railway

* No server provisioning — Railway builds and runs the container from the pinned upstream image
* Postgres attaches as a managed service instead of a self-hosted database to babysit
* TLS and the domain are handled at Railway's edge, so `OPERATELY_HOST` only needs a hostname
* Migrations run automatically on every deploy via `preDeployCommand`, no manual SSH step
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
DATABASE_URL=${{Postgres.DATABASE_URL}}     # reference to a separate Postgres service
SECRET_KEY_BASE=generate-a-secret           # Railway "generate" button; signs/encrypts cookies
OPERATELY_BLOB_TOKEN_SECRET_KEY=generate-a-secret   # signs file/blob URLs
SYSTEM_SETTINGS_ENCRYPTION_KEYS=generate-a-secret   # encrypts stored settings
OPERATELY_HOST=${{RAILWAY_PUBLIC_DOMAIN}}   # bare hostname, no scheme or port
OPERATELY_URL_SCHEME=https
ALLOW_LOGIN_WITH_EMAIL=yes    # without this + no Google OAuth, nobody can log in
ALLOW_SIGNUP_WITH_EMAIL=yes
CERT_DOMAIN=""                # must be set (empty string, not unset) — see below
CERT_EMAILS=""
CERT_DB_DIR=/opt/operately/certs
```

Set real values as Railway variables, never in a file in this repo. `PORT` defaults to `4000`
and Railway sets it for you. `requiredMountPath = "/media"` in `railway.toml` — attach a volume
there before production traffic, or uploads are lost on every redeploy.

## 🐳 Local Development

```bash
git clone https://github.com/vergissberlin/railwayapp-operately.git
cd railwayapp-operately
cp .env.example .env
docker compose up -d
docker compose exec operately /opt/operately/bin/create_db
docker compose exec operately /opt/operately/bin/migrate
```

`preDeployCommand` only runs on Railway, so run the two commands above by hand locally. Then
open http://localhost:4000.

## 🤝 Contributing

Found a bug? [Open an issue](https://github.com/vergissberlin/railwayapp-operately/issues/new)
or a pull request. See [CONTRIBUTING.md](CONTRIBUTING.md).

## 📝 License

MIT — see [LICENSE](LICENSE).

## Railway runtime defaults

* Healthcheck `/health` · Restart `ON_FAILURE` (10 retries) · Dockerfile build · TLS at Railway's
  edge, credentials only ever set as variables, never committed
* `preDeployCommand` runs `predeploy.sh` (`create_db` then `migrate`) — Railway only accepts one
  command, so chaining needed a real script, not a `&&`-joined string
* Operately reads `$PORT` directly, no start command or entrypoint wrapper needed
* `CERT_DOMAIN`/`CERT_EMAILS`/`CERT_DB_DIR` are set even though no real TLS cert is used here:
  Operately's cert-management child validates and chmods these at every boot regardless of
  `CERT_AUTO_RENEW`, and unset values crash the app. Empty strings for the first two match the
  official installer's own "skip TLS" path; `CERT_DB_DIR=/opt/operately/certs` is a
  `nobody`-owned folder baked into the image, kept outside `/media` (a volume's contents replace
  whatever the Dockerfile put at its mount path, so it isn't there by boot time).

## 📚 Resources

* [Operately docs](https://github.com/operately/operately/blob/main/docs/installation/single-host.md)
* [Railway docs](https://docs.railway.app/)

<!-- footer -->
---

[![Airbyte](https://img.shields.io/badge/Airbyte-615EFF?style=for-the-badge&logo=airbyte&logoColor=white)](https://github.com/vergissberlin/railwayapp-airbyte) [![Apache Airflow](https://img.shields.io/badge/Apache%20Airflow-017CEE?style=for-the-badge&logo=apacheairflow&logoColor=white)](https://github.com/vergissberlin/railwayapp-airflow) [![CloudBeaver](https://img.shields.io/badge/CloudBeaver-382923?style=for-the-badge&logo=dbeaver&logoColor=white)](https://github.com/vergissberlin/railwayapp-cloudbeaver-ce) [![CodiMD](https://img.shields.io/badge/CodiMD-0F766E?style=for-the-badge&logo=markdown&logoColor=white)](https://github.com/vergissberlin/railwayapp-codimd) [![Django](https://img.shields.io/badge/Django-092E20?style=for-the-badge&logo=django&logoColor=white)](https://github.com/vergissberlin/railwayapp-django) [![Email Service](https://img.shields.io/badge/Email%20Service-2563EB?style=for-the-badge&logo=maildotru&logoColor=white)](https://github.com/vergissberlin/railwayapp-email) [![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://github.com/vergissberlin/railwayapp-fastapi) [![Flask](https://img.shields.io/badge/Flask-3fad48?style=for-the-badge&logo=flask&logoColor=white)](https://github.com/vergissberlin/railwayapp-flask) [![Flowise](https://img.shields.io/badge/Flowise-4F46E5?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://github.com/vergissberlin/railwayapp-flowise) [![GitLab CE](https://img.shields.io/badge/GitLab%20CE-FC6D26?style=for-the-badge&logo=gitlab&logoColor=white)](https://github.com/vergissberlin/railwayapp-gitlab) [![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)](https://github.com/vergissberlin/railwayapp-grafana) [![Home Assistant](https://img.shields.io/badge/Home%20Assistant-18BCF2?style=for-the-badge&logo=homeassistant&logoColor=white)](https://github.com/vergissberlin/railwayapp-homeassistant) [![InfluxDB](https://img.shields.io/badge/InfluxDB-22ADF6?style=for-the-badge&logo=influxdb&logoColor=white)](https://github.com/vergissberlin/railwayapp-influxdb) [![MJML](https://img.shields.io/badge/MJML-F45E43?style=for-the-badge&logo=mjml&logoColor=white)](https://github.com/vergissberlin/railwayapp-mjml) [![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)](https://github.com/vergissberlin/railwayapp-mongodb) [![Mosquitto MQTT](https://img.shields.io/badge/Mosquitto%20MQTT-3C5280?style=for-the-badge&logo=eclipsemosquitto&logoColor=white)](https://github.com/vergissberlin/railwayapp-mqtt) [![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://github.com/vergissberlin/railwayapp-mysql) [![n8n](https://img.shields.io/badge/n8n-EA4B71?style=for-the-badge&logo=n8n&logoColor=white)](https://github.com/vergissberlin/railwayapp-n8n) [![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://github.com/vergissberlin/railwayapp-nodejs) [![Node-RED](https://img.shields.io/badge/Node-RED-8F0000?style=for-the-badge&logo=nodered&logoColor=white)](https://github.com/vergissberlin/railwayapp-nodered) [![OpenSearch](https://img.shields.io/badge/OpenSearch-005EB8?style=for-the-badge&logo=opensearch&logoColor=white)](https://github.com/vergissberlin/railwayapp-opensearch) [![Open WebUI](https://img.shields.io/badge/Open%20WebUI-D68E42?style=for-the-badge&logo=ollama&logoColor=white)](https://github.com/vergissberlin/railwayapp-openwebui) [![Operately](https://img.shields.io/badge/Operately-3185FF?style=for-the-badge&logo=operately&logoColor=white)](https://github.com/vergissberlin/railwayapp-operately) [![Outerbase Studio](https://img.shields.io/badge/Outerbase%20Studio-000000?style=for-the-badge&logo=outerbase&logoColor=white)](https://github.com/vergissberlin/railwayapp-outerbase-studio) [![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://github.com/vergissberlin/railwayapp-postgresql) [![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)](https://github.com/vergissberlin/railwayapp-redis) [![TYPO3 CMS](https://img.shields.io/badge/TYPO3%20CMS-FF8700?style=for-the-badge&logo=typo3&logoColor=white)](https://github.com/vergissberlin/railwayapp-typo3)
