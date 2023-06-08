defmodule Chatter.Models.Workspace do
  use Ecto.Schema
  import Ecto.Changeset

  alias Chatter.Accounts.User
  alias Chatter.Models.Member
  alias Chatter.Models.Channel

  @required_fields ~w(name icon_path creator_id)a

  schema "workspaces" do
    field :name, :string
    field :icon_path, :string
    belongs_to :creator, User

    has_many :channels, Channel, on_delete: :delete_all
    many_to_many :users, User, join_through: Member

    timestamps()
  end

  def changeset(workspace, attrs) do
    workspace
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
