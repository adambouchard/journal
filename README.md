# Adam Journal

Built with [Sigil](https://github.com/sigilframework/sigil) — the full-stack framework for AI products.

## Getting Started

```bash
mix setup        # Install deps, create DB, seed data
mix sigil.server  # Start at http://localhost:4000
```

**Admin:** http://localhost:4000/admin
**Login:** admin@example.com / admin123

## Deploy to Render

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy)

Set `ANTHROPIC_API_KEY` in your Render environment variables.

## Configuration

| Variable | Required | Description |
|----------|----------|-------------|
| `ANTHROPIC_API_KEY` | Yes | Your Anthropic API key |
| `GOOGLE_CALENDAR_ID` | No | Google Calendar ID for scheduling |
| `GOOGLE_CREDENTIALS_JSON` | No | Google service account credentials |

## License

MIT
