defmodule Chatter.Members do
  alias Chatter.Models.Member

  def change_member(%Member{} = _member, _attrs \\ %{}) do
  end

  def list_members_for_workspace(_workspace_id) do
  end

  def create_member_for_workspace(_workspace_id, %Member{} = _member) do
  end

  def update_member(%Member{} = _member, _attrs) do
  end

  def archive_member(%Member{} = _member) do
  end

  def delete_member(%Member{} = _member) do
  end
end
