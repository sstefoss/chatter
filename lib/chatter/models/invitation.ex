defmodule Chatter.Models.Invitation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Chatter.Models.Member
  alias Chatter.Models.Workspace

  @required_fields ~w(workspace_id sender_id email)a
  @optional_fields ~w()a

  schema "invitations" do
    field(:email, :string)
    belongs_to(:workspace, Workspace)
    belongs_to(:sender, Member, foreign_key: :sender_id)

    timestamps()
  end

  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:workspace_id, :email], name: :invitations_workspace_id_email_index)
  end
end
