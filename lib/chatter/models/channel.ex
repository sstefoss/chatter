defmodule Chatter.Models.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  alias Chatter.Models.Workspace
  alias Chatter.Models.Member
  alias Chatter.Models.Participant
  alias Chatter.Models.Message

  @required_fields ~w(name workspace_id creator_id)a
  @optional_fields ~w(description is_archived is_public)a

  schema "channels" do
    field :name, :string
    field :description, :string, default: ""
    field :is_archived, :boolean, default: false
    field :is_public, :boolean, default: true

    belongs_to :workspace, Workspace
    belongs_to :creator, Member

    has_many :messages, Message, on_delete: :delete_all
    many_to_many :members, Member, on_delete: :delete_all, join_through: Participant

    timestamps()
  end

  def changeset(channel, attrs) do
    channel
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:name, :workspace_id], name: :channels_workspace_id_name_index)
  end
end
