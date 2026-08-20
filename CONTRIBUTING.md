# Contributing to the Railway Operately Template

## Getting started

```bash
git clone https://github.com/vergissberlin/railwayapp-operately.git
cd railwayapp-operately
cp .env.example .env
docker compose up -d
```

`.env` is git-ignored on purpose. Never commit real credentials — on Railway they belong in the
project variables.

## Making changes

1. Create a branch (`git checkout -b feat/my-change`)
2. Use Conventional Commits in English (`feat:`, `fix:`, `docs:`, `chore:`)
3. Verify the container still starts and the healthcheck at `/health` responds
4. Open a pull request

Releases and version bumps are handled by release-please. Do not edit `version.txt` or
`CHANGELOG.md` by hand.

## License

By contributing you agree that your work is published under the MIT License.
