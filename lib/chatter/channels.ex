defmodule Chatter.Channels do
  alias Chatter.Repo
  alias Chatter.Models.Channel

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

  def change_channel(%Channel{} = channel, attrs \\ %{}) do
    Channel.changeset(channel, attrs)
  end

  def list_participants(%Channel{} = _channel) do
  end

  def get_channel(id), do: Repo.get!(Channel, id)

  def create_channel(attrs \\ %{}) do
    %Channel{}
    |> Channel.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:channel_created)
  end

  def update_channel(%Channel{} = channel, attrs) do
    channel
    |> Channel.changeset(attrs)
    |> Repo.update()
    |> broadcast(:channel_updated)
  end

  def archive_channel(%Channel{} = channel) do
    channel
    |> Channel.changeset(%{is_archived: true})
    |> Repo.update()
    |> broadcast(:channel_archived)
  end

  def delete_channel(%Channel{} = channel),
    do: Repo.delete(channel) |> broadcast(:channel_deleted)
end
