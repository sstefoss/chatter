defmodule Chatter.Channels do
  alias Chatter.Repo
  alias Chatter.Models.Channel
  alias Chatter.Workspaces

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
  end

  def update_channel(%Channel{} = channel, attrs) do
    channel
    |> Channel.changeset(attrs)
    |> Repo.update()
  end

  def archive_channel(%Channel{} = channel) do
    channel
    |> Channel.changeset(%{is_archived: true})
    |> Repo.update()
  end

  def delete_channel(%Channel{} = channel), do: Repo.delete(channel)
end
