defmodule Chatter.ChannelsTest do
  use Chatter.DataCase
  alias Chatter.Workspaces
  alias Chatter.Channels
  alias Chatter.Models.Channel

  import Chatter.AccountsFixtures
  import Chatter.WorkspacesFixtures
  import Chatter.ChannelsFixtures

  describe "list_participants/2" do
    test "returns the participants of a channel" do
    end
  end

  describe "get_channel/1" do
    test "returns the channel with the given id" do
      channel = channel_fixture()
      assert Channels.get_channel(channel.id) == channel
    end
  end

  describe "create_channel/1" do
    test "creates a channel with valid data" do
      creator = user_fixture()
      workspace = workspace_with_user_fixture(creator)
      member = hd(Workspaces.list_members_for_workspace(workspace))

      valid_attrs = %{
        description: "some description",
        is_public: true,
        name: "some name",
        workspace_id: workspace.id,
        creator_id: member.id
      }

      assert {:ok, %Channel{} = channel} = Channels.create_channel(valid_attrs)
      assert channel.name == valid_attrs.name
      assert channel.description == valid_attrs.description
      assert channel.is_public == valid_attrs.is_public
      assert channel.is_archived == false
    end

    test "fails to create a channel with invalid data" do
      invalid_attrs = %{
        description: "some description",
        is_public: true,
        name: "some name"
      }

      assert {:error, %Ecto.Changeset{}} = Channels.create_channel(invalid_attrs)
    end
  end

  describe "update_channel/2" do
    test "updates the channel with the given params" do
      channel = channel_fixture()

      update_attrs = %{
        name: "updated_name",
        description: "updated_description",
        is_public: false
      }

      assert {:ok, %Channel{} = updated_channel} = Channels.update_channel(channel, update_attrs)
      assert updated_channel.name == update_attrs.name
      assert updated_channel.description == update_attrs.description
      assert updated_channel.is_public == update_attrs.is_public
    end
  end

  describe "delete_channel/1" do
    test "deletes the channel given in the params" do
      channel = channel_fixture()

      assert {:ok, %Channel{}} = Channels.delete_channel(channel)
      assert_raise Ecto.NoResultsError, fn -> Channels.get_channel(channel.id) end
    end
  end

  describe "archive_channel/1" do
    test "archives the channel given in the params" do
      channel = channel_fixture()

      assert {:ok, archived_channel} = Channels.archive_channel(channel)
      assert archived_channel.is_archived == true
    end
  end
end
