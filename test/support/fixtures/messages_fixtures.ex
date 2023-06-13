defmodule Chatter.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chatter.Messages` context.
  """

  alias Chatter.Messages
  alias Chatter.Models.Member
  alias Chatter.Models.Channel

  def unique_message_text, do: "text_#{System.unique_integer()}"

  def valid_message_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      text: unique_message_text()
    })
  end

  def message_fixture(%Member{} = member1, %Member{} = member2) do
    attrs_message = %{
      recipient_id: member1.id,
      sender_id: member2.id
    }

    {:ok, message} =
      attrs_message
      |> valid_message_attributes()
      |> Messages.create_message()

    message
  end

  def message_fixture(%Member{} = member, %Channel{} = channel) do
    attrs_message = %{
      channel_id: channel.id,
      sender_id: member.id
    }

    {:ok, message} =
      attrs_message
      |> valid_message_attributes()
      |> Messages.create_message()

    message
  end
end
