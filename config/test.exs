import Config

config :adam_journal, AdamJournal.Repo,
  database: "adam_journal_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
