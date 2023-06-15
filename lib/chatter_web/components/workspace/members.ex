defmodule ChatterWeb.Workspace.Members do
  use ChatterWeb, :html

  def members(assigns) do
    ~H"""
    <div class="mt-8">
      <div class="font-semibold px-4 py-2">
        Direct messages
      </div>
      <ul class="mt-1">
        <li :for={member <- @members}>
          <.link
            patch={~p"/workspaces/#{@active_workspace}/members/#{member}"}
            class={"#{if @active_member != nil and member.id == @active_member.id, do: "bg-zinc-300 text-slate-800", else: "hover:bg-zinc-700"} rounded px-4 py-0.5 w-full block hover:cursor-pointer"}
          >
            # <%= member.username %>
          </.link>
        </li>
      </ul>
    </div>
    """
  end
end
