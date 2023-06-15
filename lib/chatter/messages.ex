defmodule Chatter.Messages do
  alias Chatter.Repo
  alias Chatter.Models.Message
  alias Chatter.Models.Channel
  # alias Chatter.Models.Member

  @pubsub Chatter.PubSub
  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(@pubsub, @topic)
  end

  def broadcast({:ok, item}, tag) do
    Phoenix.PubSub.broadcast(@pubsub, @topic, {tag, item})
    {:ok, item}
  end

  def broadcast({:error, _changeset} = error, _tag), do: error

  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  def get_message(id), do: Repo.get!(Message, id)

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:message_created)
  end

  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
    |> broadcast(:message_updated)
  end

  def delete_message(%Message{} = message),
    do: Repo.delete(message) |> broadcast(:message_deleted)

  def list_messages_for_channel(%Channel{} = channel) do
    Repo.preload(channel, messages: [:sender]).messages
  end

  # def list_messages_for_member(%Member{} = member) do
  #   Repo.preload(member, :messages).messages
  # end
end
