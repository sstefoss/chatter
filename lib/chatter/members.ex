defmodule Chatter.Members do
  alias Chatter.Repo
  alias Chatter.Models.Member

  def change_member(%Member{} = member, attrs \\ %{}) do
    Member.changeset(member, attrs)
  end

  def create_member(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  def get_member(id), do: Repo.get!(Member, id)

  def update_member(%Member{} = member, attrs) do
    member
    |> Member.changeset(attrs)
    |> Repo.update()
  end

  def archive_member(%Member{} = member) do
    member
    |> Member.changeset(%{is_archived: true})
    |> Repo.update()
  end

  def delete_member(%Member{} = member), do: Repo.delete(member)
end
