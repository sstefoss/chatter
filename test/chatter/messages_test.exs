defmodule Chatter.MessagesTest do
  use Chatter.DataCase

  alias Chatter.Members
  alias Chatter.Messages
  alias Chatter.Models.Message

  import Chatter.AccountsFixtures
  import Chatter.WorkspacesFixtures
  import Chatter.MembersFixtures
  import Chatter.MessagesFixtures
  import Chatter.ChannelsFixtures

  describe "create_message_in_channel/2" do
    test "creates a direct message between the members given in params" do
      user1 = user_fixture()
      user2 = user_fixture()
      workspace = workspace_fixture(%{creator_id: user1.id})

      member1 = member_fixture_from_user_in_workspace(user1, workspace)
      member2 = member_fixture_from_user_in_workspace(user2, workspace)

      attrs_message = %{
        recipient_id: member1.id,
        sender_id: member2.id,
        text: "A new message"
      }

      assert {:ok, message} = Messages.create_message(attrs_message)
      assert message.recipient_id == attrs_message.recipient_id
      assert message.sender_id == attrs_message.sender_id
      assert message.text == attrs_message.text
    end

    test "creates a message that will be posted in the channel" do
      user = user_fixture()
      workspace = workspace_fixture(%{creator_id: user.id})
      member = member_fixture_from_user_in_workspace(user, workspace)
      channel = channel_fixture(workspace)

      attrs_message = %{
        channel_id: channel.id,
        sender_id: member.id,
        text: "A new message"
      }

      assert {:ok, message} = Messages.create_message(attrs_message)
      assert message.channel_id == attrs_message.channel_id
      assert message.sender_id == attrs_message.sender_id
      assert message.text == attrs_message.text
    end

    test "fails to create a message without sender" do
      user = user_fixture()
      workspace = workspace_fixture(%{creator_id: user.id})
      member = member_fixture_from_user_in_workspace(user, workspace)

      attrs_message = %{
        recipient_id: member.id,
        text: "A new message"
      }

      assert {:error, %Ecto.Changeset{}} = Messages.create_message(attrs_message)
    end
  end

  describe "update_message/1" do
    test "updates a message with the given attributes" do
      user1 = user_fixture()
      user2 = user_fixture()
      workspace = workspace_fixture(%{creator_id: user1.id})
      member1 = member_fixture_from_user_in_workspace(user1, workspace)
      member2 = member_fixture_from_user_in_workspace(user2, workspace)
      message = message_fixture(member1, member2)

      update_attrs = %{
        text: "updated text"
      }

      assert {:ok, updated} = Messages.update_message(message, update_attrs)
      assert updated.text == update_attrs.text
    end
  end

  describe "delete_message/1" do
    test "deletes the message given in the params" do
      user1 = user_fixture()
      user2 = user_fixture()
      workspace = workspace_fixture(%{creator_id: user1.id})
      member1 = member_fixture_from_user_in_workspace(user1, workspace)
      member2 = member_fixture_from_user_in_workspace(user2, workspace)
      message = message_fixture(member1, member2)

      assert {:ok, %Message{}} = Messages.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message(message.id) end
    end
  end

  describe "list_messages_for_channel" do
    test "returns the messages sent in the channel given in the params" do
      user = user_fixture()
      workspace = workspace_fixture(%{creator_id: user.id})
      member = member_fixture_from_user_in_workspace(user, workspace)
      channel = channel_fixture(workspace)
      message = message_fixture(member, channel)

      messages = Messages.list_messages_for_channel(channel)
      assert length(messages) == 1
      assert hd(messages) == message
    end
  end
end
