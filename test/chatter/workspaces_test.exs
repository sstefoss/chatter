defmodule Chatter.WorkspacesTest do
  use Chatter.DataCase

  import Chatter.AccountsFixtures
  import Chatter.WorkspacesFixtures

  alias Chatter.Workspaces
  alias Chatter.Models.Workspace

  describe "create_workspace/1" do
    test "creates a workspace and generates an icon" do
      user = user_fixture()
      name = "Workspace 1"

      assert {:ok, %Workspace{} = workspace} =
               Workspaces.create_workspace(%{
                 name: name,
                 creator_id: user.id
               })

      assert workspace.name == name
      assert workspace.icon_path == "/images/workspace_icons/workspace_1_icon.jpg"
      assert workspace.creator_id == user.id
    end

    test "refuses to create a workspace without creator_id param" do
      assert {:error, %Ecto.Changeset{}} = Workspaces.create_workspace(%{name: "Workspace 1"})
    end
  end

  describe "create_workspace_with_user/2" do
    test "creates a workspace and sets the creator as admin" do
      user = user_fixture()

      assert {:ok, %Workspace{} = workspace} =
               Workspaces.create_workspace_with_user(
                 %{
                   name: "Workspace 1",
                   creator_id: user.id
                 },
                 user
               )

      assert hd(Repo.preload(workspace, [:users]).users) == user
      assert hd(Repo.preload(workspace, [:users]).members).user_id == user.id
    end
  end

  describe "add_user_in_workspace/2" do
    test "creates a workspace with a creator and adds another one" do
      creator = user_fixture()
      member = user_fixture()
      workspace = workspace_with_user_fixture(creator)

      assert {:ok, %Workspace{} = workspace} =
               Workspaces.add_user_in_workspace(workspace, member, :member)

      assert length(Repo.preload(workspace, :users).users) == 2
    end
  end

  describe "get_workspace!/1" do
    test "returns the workspace with the given id" do
      user = user_fixture()
      workspace = workspace_fixture(%{creator_id: user.id})

      assert Workspaces.get_workspace(workspace.id) == workspace
    end
  end

  describe "list_workspaces_for_user/1" do
    test "returns the workspaces for the logged in user" do
      user = user_fixture()
      workspace1 = workspace_with_user_fixture(user)
      workspace2 = workspace_with_user_fixture(user)

      assert Workspaces.list_workspaces_for_user(user) == [workspace1, workspace2]
    end
  end

  describe "list_members_for_workspace/1" do
    test "returns the members of the workspace" do
      creator = user_fixture()
      member = user_fixture()

      workspace = workspace_with_user_fixture(creator)
      Workspaces.add_user_in_workspace(workspace, member, :member)

      assert length(Workspaces.list_members_for_workspace(workspace)) == 2
    end
  end

  describe "update_workspace/2" do
    test "updates a workspace with the given attributes" do
      user = user_fixture()
      workspace = workspace_fixture(%{creator_id: user.id})
      update_attrs = %{name: "updated-name"}

      assert {:ok, %Workspace{} = workspace} =
               Workspaces.update_workspace(workspace, update_attrs)

      assert workspace.name == "updated-name"
    end

    test "update workspace with invalid data returns error changeset" do
      user = user_fixture()
      workspace1 = workspace_fixture(%{creator_id: user.id})
      workspace2 = workspace_fixture(%{creator_id: user.id})

      assert {:error, %Ecto.Changeset{}} =
               Workspaces.update_workspace(workspace1, %{name: workspace2})

      assert workspace1 == Workspaces.get_workspace(workspace1.id)
    end
  end

  describe "delete_workspace/1" do
    test "deletes the given workspace" do
      user = user_fixture()
      workspace = workspace_fixture(%{creator_id: user.id})

      assert {:ok, %Workspace{}} = Workspaces.delete_workspace(workspace)
      assert_raise Ecto.NoResultsError, fn -> Workspaces.get_workspace(workspace.id) end
    end
  end
end
