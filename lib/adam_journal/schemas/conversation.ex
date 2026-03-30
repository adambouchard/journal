defmodule AdamJournal.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "conversations" do
    field :status, :string, default: "active"
    field :title, :string

    belongs_to :agent_config, AdamJournal.AgentConfig, type: :binary_id
    has_many :messages, AdamJournal.Message, preload_order: [asc: :inserted_at]

    timestamps()
  end

  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:agent_config_id, :status, :title])
    |> validate_required([:status])
    |> validate_inclusion(:status, ["active", "closed"])
  end
end
