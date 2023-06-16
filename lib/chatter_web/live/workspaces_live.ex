defmodule ChatterWeb.WorkspacesLive do
  use ChatterWeb, :live_view
  alias Chatter.Workspaces

  def mount(_, _, socket) do
    current_user = socket.assigns.current_user
    workspaces = Workspaces.list_workspaces_for_user(current_user)

    {:ok, assign(socket, workspaces: workspaces)}
  end

  def render(assigns) do
    ~H"""
    <.center>
      <div class="py-8 px-4 mx-auto max-w-screen-xl lg:py-16 lg:px-6">
        <%= if length(@workspaces) == 0 do %>
          <h2 class="mb-4 text-4xl tracking-tight font-extrabold text-gray-900 dark:text-white">
            Welcome!
          </h2>
          <p>It looks like you are currently not part of any workspace.</p>
          <div class="mt-10">
            <.link href={~p"/workspaces/create"} class="btn w-full">
              Create your first workspace!
            </.link>
          </div>
        <% else %>
          <h2 class="mb-4 text-4xl tracking-tight font-extrabold text-gray-900 dark:text-white">
            Welcome back!
          </h2>
          <p class="font-light text-gray-500 lg:mb-16 sm:text-xl dark:text-gray-400">
            Choose a workspace below to get back to working with your team.
          </p>
          <ul>
            <li :for={workspace <- @workspaces}>
              <.link navigate={~p"/workspaces/#{workspace}"}>
                <.card class="p-4 hover:border-gray-200">
                  <div class="flex items-center">
                    <img
                    src={workspace.icon_path}
                    class="border-gray-500 border-2 rounded-lg mr-4 w-14 h-14"
                    />
                    <h3 class="text-2xl dark:text-gray-100 font-bold"><%= workspace.name %></h3>
                  </div>
                </.card>
              </.link>
            </li>
          </ul>
        <% end %>
      </div>
    </.center>
    """
  end
end
