defmodule Chatter.InvitationsFixtures do
  alias Chatter.Invitations

  def invitation_fixture(workspace, user) do
    {:ok, invitation} =
      %{
        workspace_id: workspace.id,
        email: user.email
      }
      |> Invitations.create_invitation()

    invitation
  end
end
