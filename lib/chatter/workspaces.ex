defmodule Chatter.Workspaces do
  alias Chatter.Repo
  alias Chatter.Models.Workspace
  alias Chatter.Accounts.User

  def change_workspace(%Workspace{} = _workspace, _attrs \\ %{}) do
  end

  def list_workspaces_for_user(%User{} = user) do
    user = Repo.preload(user, :workspaces)
    user.workspaces
  end

  def list_members_for_workspace(id) do
    workspace = Repo.get(Workspace, id)
    Repo.preload(workspace, :members).members
  end

  def get_workspace(id), do: Repo.get!(Workspace, id)

  def create_workspace(attrs \\ %{}) do
    %Workspace{}
    |> Workspace.changeset(attrs)
    |> Repo.insert()
  end

  def create_workspace_with_user(attrs \\ %{}, %User{} = user) do
    {:ok, workspace} = create_workspace(attrs)

    Repo.preload(workspace, :users)
    |> Workspace.changeset_add_user(user, :admin)
    |> Repo.update()

    {:ok, workspace}
  end

  def add_user_in_workspace(%Workspace{} = workspace, %User{} = user, role) do
    Repo.preload(workspace, :users)
    |> Workspace.changeset_add_user(user, role)
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
