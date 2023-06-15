defmodule ChatterWeb.ChannelsCreateLive do
  use ChatterWeb, :live_component
  alias Chatter.Channels
  alias Chatter.Models.Channel

  def mount(socket) do
    channel_changeset = Channels.change_channel(%Channel{})
    {:ok, assign(socket, channel_form: to_form(channel_changeset))}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div
        class="flex items-center hover:cursor-pointer hover:text-white mt-2 px-4"
        phx-click={show_modal("new-channel-modal")}
      >
        <div class="bg-zinc-600 rounded h-4 w-4 mr-2 flex items-center justify-center">
          <.icon name="hero-plus" class="h-3 w-3 text-slate-400" />
        </div>
        <span>Add channels</span>
      </div>
      <.modal id="new-channel-modal">
        <h3 class="text-lg text-zinc-800 font-semibold mb-4">Create a channel</h3>
        <.simple_form
          for={@channel_form}
          id="channel_form"
          phx-submit="create_channel"
          phx-target={@myself}
        >
          <.input field={@channel_form[:name]} label="Name" name="name" autocomplete="off" required />
          <.input
            field={@channel_form[:description]}
            label="Description"
            name="description"
            autocomplete="off"
          />
          <:actions>
            <.button phx-disable-with="Creating...">Create</.button>
          </:actions>
        </.simple_form>
      </.modal>
    </div>
    """
  end

  def handle_event("create_channel", %{"name" => name, "description" => description}, socket) do
    user = socket.assigns.current_user
    active_workspace = socket.assigns.active_workspace

    case Channels.create_channel(%{
           name: name,
           description: description,
           creator_id: user.id,
           workspace_id: active_workspace.id
         }) do
      {:ok, channel} ->
        socket =
          socket
          |> push_event("js-exec", %{to: "#new-channel-modal", attr: "phx-remove"})
          |> push_patch(to: ~p"/workspaces/#{active_workspace}/channels/#{channel}")

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, channel_form: to_form(changeset))}
    end
  end
end
