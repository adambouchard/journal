# Adam's Journal

> **🌐 Live at [adambouchard.com](https://adambouchard.com)**

A personal blog about AI, strategy & systems — built entirely with [Sigil](https://github.com/sigilframework/sigil), the full-stack Elixir framework for AI-powered products.

This is an example of a production application built on Sigil. It includes an AI chat assistant, tag-based filtering, slug-based SEO-friendly URLs, multi-agent routing, and a full admin panel. Everything was generated with `mix sigil.new` and customized from there.

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
