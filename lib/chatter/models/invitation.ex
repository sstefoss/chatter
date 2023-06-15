defmodule Chatter.Models.Invitation do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(workspace_id email)a
  @optional_fields ~w()a

  schema "invitations" do
    field(:email, :string)
    belongs_to(:workspace, Workspace)

    timestamps()
  end

  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:workspace_id, :email], name: :invitations_workspace_id_email_index)
  end
end
