defmodule Chatter.Models.Member do
  use Ecto.Schema
  import Ecto.Changeset

  alias Chatter.Accounts
  alias Chatter.Accounts.User
  alias Chatter.Models.Workspace
  alias Chatter.Models.Participant
  alias Chatter.Models.Channel

  @required_fields ~w(workspace_id user_id)a
  @optional_fields ~w(username fullname avatar role is_archived)a

  schema "members" do
    field :username, :string
    field :fullname, :string
    field :avatar, :string
    field :role, Ecto.Enum, values: [:admin, :moderator, :member], default: :member
    field :is_archived, :boolean, default: false

    belongs_to :workspace, Workspace
    belongs_to :user, User

    many_to_many :channels, Channel, join_through: Participant

    timestamps()
  end

  def changeset(member, attrs) do
    member
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> check_username()
    |> unique_constraint([:user_id, :workspace_id], name: :members_user_id_workspace_id_index)
    |> unique_constraint([:workspace_id, :username], name: :members_workspace_id_username_index)
  end

  def check_username(changeset) do
    case get_change(changeset, :username) do
      nil -> generate_username(changeset)
      _ -> changeset
    end
  end

  def generate_username(changeset) do
    case get_change(changeset, :user_id) do
      nil ->
        changeset

      user_id ->
        user = Accounts.get_user!(user_id)

        username =
          user.email
          |> String.split("@")
          |> hd()

        put_change(changeset, :username, username)
    end
  end
end
