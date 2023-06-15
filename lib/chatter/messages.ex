defmodule Chatter.Messages do
  alias Chatter.Repo
  alias Chatter.Models.Message

  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  def get_message(id), do: Repo.get!(Message, id)

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  def delete_message(%Message{} = message), do: Repo.delete(message)

  def list_messages_for_channel(%Channel{} = channel) do
    Repo.preload(channel, :messages).messages
  end
end
