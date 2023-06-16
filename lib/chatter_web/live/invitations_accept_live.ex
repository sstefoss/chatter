defmodule ChatterWeb.InvitationsAcceptLive do
  use ChatterWeb, :live_view
  alias Chatter.Invitations
  alias Chatter.Workspaces

  def mount(%{"id" => id}, _session, socket) do
    current_user = socket.assigns.current_user
    invitation = Invitations.get_invitation_by_id(id)
    workspace = Workspaces.get_workspace(invitation.workspace_id)

    case Invitations.is_user_invited?(current_user, invitation) do
      {:error, reason} ->
        {:ok,
         socket
         |> put_flash(:error, reason)
         |> redirect(to: ~p"/")}

      {:ok, _} ->
        {:ok, assign(socket, invitation: invitation, workspace: workspace)}
    end
  end

  def render(assigns) do
    ~H"""
      <div class="flex justify-center items-center h-full">
        <.card class="max-w-xl">
          <.header class="mb-10">
            You are invited to join <%= @workspace.name %>
            <:subtitle>
              In order to join the workspace you need to accept the invitation
            </:subtitle>
          </.header>

          <div class="flex justify-center">
            <.button phx-click="accept_invitation">Accept invitation</.button>
          </div>
        </.card>
      </div>
    """
  end

  def handle_event("accept_invitation", _, socket) do
    invitation = socket.assigns.invitation
    current_user = socket.assigns.current_user

    {:ok, workspace} = Invitations.accept_invitation_for_user(invitation, current_user)
    {:noreply, push_navigate(socket, to: ~p"/workspaces/#{workspace}")}
  end
end
