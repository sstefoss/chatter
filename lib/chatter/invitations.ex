defmodule Chatter.Invitations do
  import Ecto.Query
  alias Chatter.Models.Invitation
  alias Chatter.Repo
  alias Chatter.Accounts.User
  alias Chatter.Workspaces

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

  def change_invitation(%Invitation{} = invitation, attrs \\ %{}) do
    Invitation.changeset(invitation, attrs)
  end

  def is_user_invited?(%User{} = user, %Invitation{} = invitation) do
    case invitation.email != user.email do
      true -> {:error, "User is not invited"}
      false -> {:ok, invitation}
    end
  end

  def get_invitation(workspace_id, email) do
    from(i in Invitation,
      where: i.email == ^email and i.workspace_id == ^workspace_id
    )
    |> Repo.one!()
  end

  def get_invitation_by_id(id), do: Repo.get!(Invitation, id)

  def get_invitations_for_workspace(workspace) do
    Repo.preload(workspace, :invitations).invitations
  end

  def create_invitation(attrs \\ %{}) do
    %Invitation{}
    |> Invitation.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:invitation_created)
  end

  def update_invitation(%Invitation{} = invitation, attrs) do
    invitation
    |> Invitation.changeset(attrs)
    |> Repo.update()
    |> broadcast(:invitation_updated)
  end

  def delete_invitation(%Invitation{} = invitation),
    do: Repo.delete(invitation) |> broadcast(:invitation_deleted)

  def accept_invitation_for_user(%Invitation{} = invitation, %User{} = user) do
    case is_user_invited?(user, invitation) do
      {:error, reason} ->
        {:error, reason}

      {:ok, _} ->
        Workspaces.get_workspace(invitation.workspace_id)
        |> Workspaces.add_user_in_workspace(user, :member)

        delete_invitation(invitation)
    end
  end
end
