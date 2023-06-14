defmodule Chatter.MembersTest do
  use Chatter.DataCase
  import Chatter.AccountsFixtures
  import Chatter.WorkspacesFixtures
  import Chatter.MembersFixtures

  alias Chatter.Members
  alias Chatter.Models.Member

  describe "create_member/1" do
    test "creates a member with valid attributes" do
      creator = user_fixture()
      workspace = workspace_with_user_fixture(creator)
      member_fix = user_fixture()

      valid_attrs = %{
        user_id: member_fix.id,
        workspace_id: workspace.id,
        username: "stef",
        fullname: "Stefanos Orovas",
        avatar: "/avatar/path",
        role: :member
      }

      assert {:ok, %Member{} = member} = Members.create_member(valid_attrs)

      assert member.user_id == member_fix.id
      assert member.workspace_id == member.workspace_id
      assert member.username == member.username
      assert member.fullname == member.fullname
      assert member.avatar == member.avatar
      assert member.role == member.role
    end

    test "creates a member and generates username generated from email" do
      creator = user_fixture()
      workspace = workspace_with_user_fixture(creator)
      user_fix = user_fixture()

      valid_attrs = %{
        user_id: user_fix.id,
        workspace_id: workspace.id,
        role: :member
      }

      assert {:ok, %Member{} = member} = Members.create_member(valid_attrs)
      assert String.contains?(user_fix.email, member.username)
    end

    test "fails to create a member with invalid attributes" do
      invalid_attrs = %{
        username: "stef",
        fullname: "Stefanos Orovas",
        avatar: "/avatar/path",
        role: :member
      }

      assert {:error, %Ecto.Changeset{}} = Members.create_member(invalid_attrs)
    end
  end

  describe "update_member/2" do
    test "updates a member with the given attributes" do
      creator = user_fixture()
      workspace = workspace_with_user_fixture(creator)
      user = user_fixture()

      member = member_fixture_from_user_in_workspace(user, workspace)

      update_attrs = %{
        username: "test_username",
        fullname: "test_fullname",
        avatar: "/avatar/path",
        role: :moderator
      }

      assert {:ok, %Member{} = updated_member} = Members.update_member(member, update_attrs)
      assert updated_member.username == update_attrs.username
      assert updated_member.fullname == update_attrs.fullname
      assert updated_member.avatar == update_attrs.avatar
      assert updated_member.role == update_attrs.role
    end
  end

  describe "archive_member/1" do
    test "archives a member" do
      creator = user_fixture()
      workspace = workspace_with_user_fixture(creator)
      user = user_fixture()
      member = member_fixture_from_user_in_workspace(user, workspace)

      assert {:ok, %Member{} = updated_member} = Members.archive_member(member)
      assert updated_member.is_archived == true
    end
  end

  describe "delete_member/1" do
    test "deletes a member" do
      creator = user_fixture()
      workspace = workspace_with_user_fixture(creator)
      user = user_fixture()
      member = member_fixture_from_user_in_workspace(user, workspace)

      assert {:ok, %Member{}} = Members.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> Members.get_member(member.id) end
    end
  end

  describe "get_member_for_user_in_workspace/2" do
    test "returns the related member instance from a user in a workspace" do
      creator = user_fixture()
      workspace = workspace_with_user_fixture(creator)

      member = Members.get_member_for_user_in_workspace(creator, workspace)
      assert member.workspace_id == workspace.id
      assert member.user_id == creator.id
    end
  end
end
