defmodule Chatter.Invitations do
  import Ecto.Query
  alias Chatter.Models.Invitation
  alias Chatter.Repo

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

  def get_invitation(workspace_id, email) do
    from(i in Invitation,
      where: i.email == ^email and i.workspace_id == ^workspace_id
    )
    |> Repo.one!()
  end

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
end
