defmodule Chatter.WorkspacesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chatter.Workspaces` context.
  """

  alias Chatter.Accounts.User
  alias Chatter.Workspaces

  def unique_workspace_name, do: "team #{System.unique_integer()}"

  def valid_workspace_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      name: unique_workspace_name()
    })
  end

  def workspace_fixture(attrs \\ %{}) do
    {:ok, workspace} =
      attrs
      |> valid_workspace_attributes()
      |> Workspaces.create_workspace()

    workspace
  end

  def workspace_with_user_fixture(%User{} = user) do
    {:ok, workspace} =
      Workspaces.launch_new_workspace(
        user,
        %{
          name: unique_workspace_name(),
          creator_id: user.id
        }
      )

    workspace
  end
end
