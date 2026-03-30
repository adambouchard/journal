defmodule AdamJournal.Application do
  use Application

  @impl true
  def start(_type, _args) do
    # Start :pg scope for conversation real-time sync
    :pg.start_link(:adam_journal_conversations)

    children = [
      AdamJournal.Repo,
      {Bandit, plug: AdamJournal.Router, port: 4000}
    ]

    opts = [strategy: :one_for_one, name: AdamJournal.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
