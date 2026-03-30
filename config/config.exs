import Config

config :adam_journal, AdamJournal.Repo,
  database: "adam_journal_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool_size: 10

config :adam_journal,
  ecto_repos: [AdamJournal.Repo]

config :sigil,
  secret_key_base: "zFDotF98OEGKvgsa4XYG_ZTkUIXaPZ-NmjCv-KD9ZgZUGeEaGCKIYJ1NU36qZPqN",
  repo: AdamJournal.Repo,
  auth_repo: AdamJournal.Repo,
  otp_app: :adam_journal

import_config "#{config_env()}.exs"
