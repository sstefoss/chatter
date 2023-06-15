defmodule ChatterWeb.Workspace.Workspaces do
  use ChatterWeb, :html

  def workspaces(assigns) do
    ~H"""
    <ul>
      <li :for={workspace <- @workspaces} class="mb-4">
        <.link patch={~p"/workspaces/#{workspace}"}>
          <img
            src={workspace.icon_path}
            class={"#{if workspace.id == @active_workspace.id, do: "border-gray-200", else: "border-gray-500"} hover:border-gray-200 border-2 rounded-lg w-10 h-10"}
          />
        </.link>
      </li>
    </ul>
    <div class="mt-2">
      <.link navigate={~p"/workspaces/create"} class="bg-gray-300 hover:bg-gray-100 rounded-lg p-2">
        <.icon name="hero-plus" class="bg-gray-800 align-sub" />
      </.link>
    </div>
    """
  end
end
