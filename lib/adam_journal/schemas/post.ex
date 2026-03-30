defmodule AdamJournal.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "posts" do
    field :title, :string
    field :slug, :string
    field :body, :string, default: ""
    field :tags, {:array, :string}, default: []
    field :published, :boolean, default: false
    field :published_at, :utc_datetime

    timestamps()
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :slug, :body, :tags, :published, :published_at])
    |> validate_required([:title])
    |> maybe_generate_slug()
    |> unique_constraint(:slug)
    |> maybe_set_published_at()
  end

  defp maybe_generate_slug(changeset) do
    case get_change(changeset, :slug) do
      nil ->
        case get_change(changeset, :title) do
          nil -> changeset
          title -> put_change(changeset, :slug, slugify(title))
        end

      _ ->
        changeset
    end
  end

  @doc "Generate a URL-friendly slug from a string."
  def slugify(text) when is_binary(text) do
    text
    |> String.downcase()
    |> String.replace(~r/[^\w\s-]/u, "")
    |> String.replace(~r/[\s_]+/, "-")
    |> String.replace(~r/-+/, "-")
    |> String.trim("-")
  end

  def slugify(_), do: ""

  defp maybe_set_published_at(changeset) do
    if get_change(changeset, :published) == true && is_nil(get_field(changeset, :published_at)) do
      put_change(changeset, :published_at, DateTime.utc_now() |> DateTime.truncate(:second))
    else
      changeset
    end
  end
end
