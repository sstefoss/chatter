defmodule Chatter.InvitationsTest do
  use Chatter.DataCase

  alias Chatter.Invitations
  alias Chatter.Workspaces
  alias Chatter.Models.Invitation
  import Chatter.AccountsFixtures
  import Chatter.WorkspacesFixtures
  import Chatter.InvitationsFixtures
  import Chatter.MembersFixtures

  describe "get_invitation" do
    test "returns invitation with the given params" do
      user = user_fixture()
      workspace = workspace_fixture(%{creator_id: user.id})
      invitation = invitation_fixture(workspace, user, "invited@workspace.com")

      assert Invitations.get_invitation(invitation.workspace_id, invitation.email) == invitation
    end

    test "fails to retrieve invitation that doesn't exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Invitations.get_invitation(0, "")
      end
    end
  end

  describe "get_invitations_for_workspace" do
    test "returns invitations of the given workspace" do
      user = user_fixture()
      workspace = workspace_fixture(%{creator_id: user.id})
      invitation = invitation_fixture(workspace, user, "invited@workspace.com")

      assert Invitations.get_invitations_for_workspace(workspace) == [invitation]
    end
  end

  describe "create_invitation" do
    test "creates a new invitation" do
      user = user_fixture()
      workspace = workspace_fixture(%{creator_id: user.id})
      member = member_fixture_from_user_in_workspace(user, workspace)

      attrs = %{
        workspace_id: workspace.id,
        email: "invited@workspace.com",
        sender_id: member.id
      }

      assert {:ok, %Invitation{} = invitation} = Invitations.create_invitation(attrs)
      assert invitation.email == attrs.email
      assert invitation.workspace_id == attrs.workspace_id
    end
  end

  describe "update_invitation" do
    test "updates the invitation's email" do
      user = user_fixture()
      workspace = workspace_fixture(%{creator_id: user.id})
      invitation = invitation_fixture(workspace, user, "invited@workspace.com")

      update_attrs = %{
        email: "updated@email.com"
      }

      assert {:ok, %Invitation{} = invitation} =
               Invitations.update_invitation(invitation, update_attrs)

      assert invitation.email == update_attrs.email
    end
  end

  describe "delete_invitation" do
    test "deletes the given invitation" do
      user = user_fixture()
      workspace = workspace_fixture(%{creator_id: user.id})
      invitation = invitation_fixture(workspace, user, "invited@workspace.com")

      assert {:ok, %Invitation{}} = Invitations.delete_invitation(invitation)

      assert_raise Ecto.NoResultsError, fn ->
        Invitations.get_invitation(invitation.workspace_id, invitation.email)
      end
    end
  end

  describe "accept_invitation_for_user/2" do
    test "creates a member, adds it in the workspace and deletes the invitation" do
      user = user_fixture()
      workspace = workspace_fixture(%{creator_id: user.id})

      email = "invited@workspace.com"
      invited_user = user_with_email_fixture(%{email: email})
      invitation = invitation_fixture(workspace, user, email)

      assert {:ok, deleted_invitation} =
               Invitations.accept_invitation_for_user(invitation, invited_user)

      assert length(Workspaces.list_members_for_workspace(workspace)) == 2

      assert_raise Ecto.NoResultsError, fn ->
        Invitations.get_invitation_by_id(deleted_invitation.id)
      end
    end

    test "rejects invitation when user is not invited" do
      user = user_fixture()
      workspace = workspace_fixture(%{creator_id: user.id})

      non_invited_user = user_fixture()
      invitation = invitation_fixture(workspace, user, "invited@workspace.com")

      assert {:error, _} = Invitations.accept_invitation_for_user(invitation, non_invited_user)
    end
  end
end
