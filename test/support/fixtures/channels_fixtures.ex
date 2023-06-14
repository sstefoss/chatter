defmodule Chatter.ChannelsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chatter.Workspaces` context.
  """

  import Chatter.WorkspacesFixtures
  import Chatter.AccountsFixtures

  alias Chatter.Models.Workspace
  alias Chatter.Workspaces
  alias Chatter.Channels

  def unique_channel_name, do: "name_#{System.unique_integer()}"
  def unique_channel_description, do: "description_#{System.unique_integer()}"

  def valid_channel_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      name: unique_channel_name(),
      description: unique_channel_description(),
      is_public: true
    })
  end

  def channel_fixture() do
    creator = user_fixture()
    workspace = workspace_with_user_fixture(creator)
    member = hd(Workspaces.list_members_for_workspace(workspace))

    valid_attrs = %{
      workspace_id: workspace.id,
      creator_id: member.id
    }

    {:ok, channel} =
      valid_attrs
      |> valid_channel_attributes()
      |> Channels.create_channel()

    channel
  end

  def channel_fixture(%Workspace{} = workspace) do
    member = hd(Workspaces.list_members_for_workspace(workspace))

    valid_attrs = %{
      workspace_id: workspace.id,
      creator_id: member.id
    }

    {:ok, channel} =
      valid_attrs
      |> valid_channel_attributes()
      |> Channels.create_channel()

    channel
  end
end
