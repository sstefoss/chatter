defmodule Chatter.Messages do
  alias Chatter.Models.Message

  def change_message(%Message{} = _message, _attrs \\ %{}) do
  end

  def list_messages_for_channel(_channel_id) do
  end

  def list_direct_messages_for_user(_user_id, _from_user_id) do
  end

  def create_message_in_channel(_channel_id, %Message{} = _message) do
  end

  def create_direct_message(_to_user, %Message{} = _message) do
  end

  def update_message(%Message{} = _message, _attrs) do
  end

  def delete_message(%Message{} = _message) do
  end
end
