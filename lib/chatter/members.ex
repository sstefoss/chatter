defmodule Chatter.Members do
  import Ecto.Query
  alias Chatter.Repo
  alias Chatter.Models.Workspace
  alias Chatter.Models.Member
  alias Chatter.Accounts.User

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

  def get_member_for_user_in_workspace(%User{} = user, %Workspace{} = workspace) do
    user_id = user.id
    workspace_id = workspace.id

    query =
      from member in Member,
        where: member.user_id == ^user_id and member.workspace_id == ^workspace_id

    Repo.one(query)
  end
end
