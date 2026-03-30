import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise "DATABASE_URL not set"

  config :adam_journal, AdamJournal.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: [verify: :verify_none]

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "SECRET_KEY_BASE not set"

  # Plug requires at least 64 bytes — Render's generateValue may be shorter
  secret_key_base =
    if byte_size(secret_key_base) < 64 do
      :crypto.hash(:sha512, secret_key_base) |> Base.encode64(padding: false)
    else
      secret_key_base
    end

  config :sigil,
    secret_key_base: secret_key_base
end

# API Keys (all environments)
config :sigil,
  anthropic_api_key: System.get_env("ANTHROPIC_API_KEY")

# Google Calendar (optional)
if System.get_env("GOOGLE_CALENDAR_ID") do
  config :adam_journal, :google_calendar,
    calendar_id: System.get_env("GOOGLE_CALENDAR_ID"),
    credentials: System.get_env("GOOGLE_CREDENTIALS_JSON")
end
