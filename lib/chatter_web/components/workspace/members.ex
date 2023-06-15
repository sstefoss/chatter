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
            class={"#{if @active_member != nil and member.id == @active_member.id, do: "bg-zinc-300 text-slate-900", else: "hover:bg-zinc-700"} rounded px-4 py-0.5 w-full block hover:cursor-pointer flex items-baseline"}
          >
            <span class="w-3 h-3 mr-2 rounded-full bg-green-400 block" />
            <span><%= member.username %></span>
          </.link>
        </li>
      </ul>
      <ul>
        <li :for={invitation <- @invitations}>
          <.link
            patch={~p"/workspaces/#{@active_workspace}/invitations/#{invitation}"}
            class={"#{if @active_invitation != nil and invitation.id == @active_invitation.id, do: "bg-zinc-300 text-slate-900", else: "hover:bg-zinc-700"} rounded px-4 py-0.5 w-full block hover:cursor-pointer flex items-baseline"}
          >
            <span class="w-3 h-3 mr-2 rounded-full border border-slate-400 block" />
            <span><%= invitation.email %></span>
          </.link>
        </li>
      </ul>
    </div>
    """
  end
end
