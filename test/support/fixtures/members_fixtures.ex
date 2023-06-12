defmodule Chatter.MembersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chatter.Workspaces` context.
  """

  import Chatter.WorkspacesFixtures

  alias Chatter.Models.Workspace
  alias Chatter.Accounts.User
  alias Chatter.Members

  def unique_member_username, do: "username_#{System.unique_integer()}"
  def unique_member_fullname, do: "fullname_#{System.unique_integer()}"
  def unique_member_avatar, do: "/avatar/#{System.unique_integer()}"

  def valid_member_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      username: unique_member_username(),
      fullname: unique_member_fullname(),
      avatar: unique_member_avatar(),
      role: :member
    })
  end

  def member_fixture_from_user_in_workspace(%User{} = user, %Workspace{} = workspace) do
    valid_attrs = %{
      user_id: user.id,
      workspace_id: workspace.id
    }

    {:ok, member} =
      valid_attrs
      |> valid_member_attributes()
      |> Members.create_member()

    member
  end
end
