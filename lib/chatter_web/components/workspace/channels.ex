defmodule ChatterWeb.Workspace.Channels do
  use ChatterWeb, :html

  def channels(assigns) do
    ~H"""
    <div class="font-semibold mt-2 py-2 px-4">
      Channels
    </div>
    <ul class="mt-1">
      <li :for={channel <- @channels}>
        <.link
          patch={~p"/workspaces/#{@active_workspace}/channels/#{channel}"}
          class={"#{if @active_channel != nil and channel.id == @active_channel.id, do: "bg-zinc-300 text-slate-900", else: "hover:bg-zinc-700"} rounded px-4 py-0.5 w-full block hover:cursor-pointer"}
        >
          # <%= channel.name %>
        </.link>
      </li>
    </ul>
    """
  end
end
