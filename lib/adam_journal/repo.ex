defmodule AdamJournal.Repo do
  use Ecto.Repo,
    otp_app: :adam_journal,
    adapter: Ecto.Adapters.Postgres
end
