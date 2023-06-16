defmodule Chatter.InvitationsFixtures do
  alias Chatter.Invitations
  import Chatter.MembersFixtures

  def invitation_fixture(workspace, user, email) do
    member = member_fixture_from_user_in_workspace(user, workspace)

    {:ok, invitation} =
      %{
        workspace_id: workspace.id,
        email: email,
        sender_id: member.id
      }
      |> Invitations.create_invitation()

    invitation
  end
end
