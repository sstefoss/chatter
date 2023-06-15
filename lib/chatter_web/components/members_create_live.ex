defmodule ChatterWeb.MembersCreateLive do
  use ChatterWeb, :live_component
  alias Chatter.Members
  alias Chatter.Models.Member

  def mount(socket) do
    members_changeset = Members.change_member(%Member{})
    {:ok, assign(socket, members_form: to_form(members_changeset))}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div
        class="flex items-center hover:cursor-pointer hover:text-white mt-2 px-4"
        phx-click={show_modal("new-members-modal")}
      >
        <div class="bg-zinc-600 rounded h-4 w-4 mr-2 flex items-center justify-center">
          <.icon name="hero-plus" class="h-3 w-3 text-slate-400" />
        </div>
        <span>Add coworkers</span>
      </div>
      <.modal id="new-members-modal">
        <h3 class="text-lg text-zinc-800 font-semibold mb-4">Add a coworker</h3>
        <.simple_form
          for={@members_form}
          id="members_form"
          phx-submit="add_members"
          phx-target={@myself}
        >
          <.input field={@members_form[:name]} label="Name" name="name" autocomplete="off" required />
          <:actions>
            <.button phx-disable-with="Creating...">Create</.button>
          </:actions>
        </.simple_form>
      </.modal>
    </div>
    """
  end

  def handle_event("add_members", _, socket) do
    {:noreply, socket}
  end
end
