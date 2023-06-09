defmodule Chatter.WorkspacesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chatter.Workspaces` context.
  """

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
      |> Chatter.Workspaces.create_workspace()

    workspace
  end
end
