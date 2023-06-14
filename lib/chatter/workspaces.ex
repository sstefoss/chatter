defmodule Chatter.Workspaces do
  alias Chatter.Repo
  alias Chatter.Models.Workspace
  alias Chatter.Models.Channel
  alias Chatter.Accounts.User
  alias Chatter.Members
  alias Chatter.Models.Member

  def change_workspace(%Workspace{} = workspace, attrs \\ %{}) do
    Workspace.changeset(workspace, attrs)
  end

  def list_workspaces_for_user(%User{} = user) do
    user = Repo.preload(user, :workspaces)
    user.workspaces
  end

  def list_members_for_workspace(workspace) do
    Repo.preload(workspace, :members).members
  end

  def list_channels_for_workspace(workspace) do
    Repo.preload(workspace, :channels).channels
  end

  def get_workspace(id), do: Repo.get!(Workspace, id)

  def create_workspace(attrs \\ %{}) do
    %Workspace{}
    |> Workspace.changeset(attrs)
    |> Repo.insert()
  end

  def launch_new_workspace(%User{} = user, attrs \\ %{}) do
    with {:ok, workspace} <- create_workspace(attrs),
         {:ok, workspace} <- add_user_in_workspace(workspace, user, :admin),
         {:ok, workspace} <-
           add_channel_in_workspace(workspace, %Channel{
             name: "general",
             description: "General purpose",
             workspace_id: workspace.id,
             creator_id: Members.get_member_for_user_in_workspace(user, workspace).id
           }),
         {:ok, workspace} <-
           add_channel_in_workspace(workspace, %Channel{
             name: "random",
             description: "Random conversations",
             workspace_id: workspace.id,
             creator_id: Members.get_member_for_user_in_workspace(user, workspace).id
           }) do
      {:ok, workspace}
    end
  end

  def add_user_in_workspace(%Workspace{} = workspace, %User{} = user, role) do
    member =
      Members.change_member(%Member{}, %{
        workspace_id: workspace.id,
        user_id: user.id,
        user: user,
        role: role
      })

    Repo.preload(workspace, :members)
    |> Workspace.changeset_add_member(member)
    |> Repo.update()

    {:ok, workspace}
  end

  def add_channel_in_workspace(%Workspace{} = workspace, %Channel{} = channel) do
    Repo.preload(workspace, :channels)
    |> Workspace.changeset_add_channel(channel)
    |> Repo.update()

    {:ok, workspace}
  end

  def update_workspace(%Workspace{} = workspace, attrs) do
    workspace
    |> Workspace.changeset(attrs)
    |> Repo.update()
  end

  def delete_workspace(%Workspace{} = workspace), do: Repo.delete(workspace)
end
