defmodule ChatterWeb.InvitationsCreateLive do
  use ChatterWeb, :live_component
  alias Chatter.Invitations
  alias Chatter.Models.Invitation
  alias Chatter.Members

  def mount(socket) do
    invitations_changeset = Invitations.change_invitation(%Invitation{})
    {:ok, assign(socket, invitations_form: to_form(invitations_changeset))}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div
        class="flex items-center hover:cursor-pointer hover:text-white mt-2 px-4"
        phx-click={show_modal("new-invitations-modal")}
      >
        <div class="bg-zinc-600 rounded h-4 w-4 mr-2 flex items-center justify-center">
          <.icon name="hero-plus" class="h-3 w-3 text-slate-400" />
        </div>
        <span>Add coworkers</span>
      </div>
      <.modal id="new-invitations-modal">
        <h3 class="text-lg text-zinc-800 font-semibold mb-4">Add a coworker</h3>
        <.simple_form
          for={@invitations_form}
          id="invitations_form"
          phx-submit="create_invitation"
          phx-target={@myself}
        >
          <.input field={@invitations_form[:email]} label="Email" name="email" autocomplete="off" required />
          <:actions>
            <.button phx-disable-with="Creating...">Send invitation</.button>
          </:actions>
        </.simple_form>
      </.modal>
    </div>
    """
  end

  def handle_event("create_invitation", %{"email" => email}, socket) do
    workspace = socket.assigns.active_workspace
    user = socket.assigns.current_user

    member = Members.get_member_for_user_in_workspace(user, workspace)

    case Invitations.create_invitation(%{
           email: email,
           workspace_id: workspace.id,
           sender_id: member.id
         }) do
      {:ok, _} ->
        {:noreply,
         socket
         |> push_event("js-exec", %{to: "#new-invitations-modal", attr: "phx-remove"})}

      {:error, changeset} ->
        {:noreply, assign(socket, channel_form: to_form(changeset))}
    end
  end
end
