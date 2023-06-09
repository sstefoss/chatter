defmodule Chatter.Channels do
  alias Chatter.Models.Channel

  def change_channel(%Channel{} = _channel, _attrs \\ %{}) do
  end

  def list_channels_for_workspace(_workspace_id) do
  end

  def list_participants(%Channel{} = _channel) do
  end

  def get_channel(_id) do
  end

  def create_channel_for_workspace(_workspace_id, _attrs \\ %{}) do
  end

  def update_channel(%Channel{} = _channel, _attrs) do
  end

  def delete_channel(%Channel{} = _channel) do
  end

  def archive_channel(%Channel{} = _channel) do
  end
end
