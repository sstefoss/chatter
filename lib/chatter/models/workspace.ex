defmodule Chatter.Models.Workspace do
  use Ecto.Schema
  import Ecto.Changeset

  alias Chatter.Accounts.User
  alias Chatter.Models.Member
  alias Chatter.Models.Channel
  alias Chatter.Iconify

  @required_fields ~w(name creator_id)a

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
    |> generate_icon_path()
  end

  defp generate_icon_path(changeset) do
    case get_change(changeset, :name) do
      nil -> changeset
      name -> put_change(changeset, :icon_path, Iconify.make_icon(name))
    end
  end
end
