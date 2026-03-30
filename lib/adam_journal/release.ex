defmodule AdamJournal.Release do
  @moduledoc """
  Release tasks for production (migrations, seeds).
  Called from entrypoint.sh before the app starts.
  """

  @app :adam_journal

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} =
        Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def seed do
    load_app()

    for repo <- repos() do
      {:ok, _, _} =
        Ecto.Migrator.with_repo(repo, fn _repo ->
          seed_file = priv_path_for(repo, "seeds.exs")
          if File.exists?(seed_file), do: Code.eval_file(seed_file)
        end)
    end
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config(), :otp_app)
    Application.app_dir(app, ["priv", "repo", filename])
  end
end
