defmodule ChatterWeb.WorkspacesCreateLive do
  use ChatterWeb, :live_view
  alias Chatter.Workspaces
  alias Chatter.Models.Workspace

  def mount(_, _, socket) do
    changeset = Workspaces.change_workspace(%Workspace{})
    {:ok, assign(socket, :workspace_form, to_form(changeset))}
  end

  def render(assigns) do
    ~H"""
    <.center>
      <.header>
        Create a workspace
        <:subtitle>Start by creating a new workspace</:subtitle>
      </.header>
      <.simple_form
        for={@workspace_form}
        id="workspace_form"
        phx-submit="create_workspace"
        class="mt-8"
      >
        <.input field={@workspace_form[:name]} label="Name" name="name" required />
        <:actions>
          <.button class="w-full" phx-disable-with="Creating...">Create</.button>
        </:actions>
      </.simple_form>
    </.center>
    """
  end

  def handle_event("create_workspace", %{"name" => name}, socket) do
    user = socket.assigns.current_user

    attrs = %{
      name: name,
      creator_id: user.id
    }

    case Workspaces.create_workspace_with_user(
           attrs,
           user
         ) do
      {:ok, workspace} ->
        {:noreply,
         socket
         |> put_flash(:info, "Workspace #{name} created successfully.")
         |> redirect(to: ~p"/workspaces/#{workspace}")}

      {:error, changeset} ->
        {:noreply, assign(socket, workspace_form: to_form(changeset))}
    end
  end
end
