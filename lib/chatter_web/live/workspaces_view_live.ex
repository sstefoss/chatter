defmodule ChatterWeb.WorkspacesViewLive do
  use ChatterWeb, :live_view

  alias Chatter.Workspaces
  alias Chatter.Channels
  alias Chatter.Members
  alias Chatter.Messages
  alias Chatter.Models.Workspace

  alias ChatterWeb.WorkspacesListLive
  alias ChatterWeb.ChannelsCreateLive
  alias ChatterWeb.MessagesCreateLive

  def mount(_, _, socket) do
    current_user = socket.assigns.current_user

    workspaces = Workspaces.list_workspaces_for_user(current_user)
    active_workspace = hd(workspaces)

    members = Workspaces.list_members_for_workspace(active_workspace)

    channels = Workspaces.list_channels_for_workspace(active_workspace)
    active_channel = hd(channels)

    messages = Messages.list_messages_for_channel(active_channel)

    {:ok,
     assign(socket,
       workspaces: workspaces,
       active_workspace: active_workspace,
       members: members,
       active_member: nil,
       channels: channels,
       active_channel: active_channel,
       messages: messages
     )}
  end

  def handle_params(%{"channel_id" => channel_id, "id" => _}, _uri, socket) do
    channel = Channels.get_channel(channel_id)
    messages = Messages.list_messages_for_channel(channel)
    {:noreply, assign(socket, active_channel: channel, active_member: nil, messages: messages)}
  end

  def handle_params(%{"member_id" => member_id, "id" => _}, _uri, socket) do
    member = Members.get_member(member_id)
    {:noreply, assign(socket, active_channel: nil, active_member: member)}
  end

  def handle_params(_, _, socket), do: {:noreply, socket}

  def render(assigns) do
    ~H"""
    <div class="flex h-full border border-zinc-700">
      <aside class="w-16 h-full py-4 bg-zinc-900 flex flex-col items-center">
        <%= render_workspaces(assigns) %>
      </aside>
      <div class="w-60 border-x border-zinc-700 text-gray-300 overflow-auto">
        <div class="font-semibold py-2 px-6 text-xl border-b border-zinc-700 text-white sticky top-0 bg-zinc-900">
          <%= @active_workspace.name %>
        </div>
        <div class="px-2">
          <%= render_channels(assigns) %>
        </div>
        <div class="px-2">
          <%= render_members(assigns) %>
        </div>
      </div>
      <div class="flex flex-col flex-1">
        <div class="flex-none py-2 px-6 border-b border-zinc-700 flex items-center">
          <%= if @active_channel != nil do %>
            <div class="text-gray-200 text-lg font-semibold">
              # <%= @active_channel.name %>
            </div>
            <div class="text-gray-400 ml-6 text-sm">
              <%= @active_channel.description %>
            </div>
          <% else %>
            <div class="text-gray-200 text-lg font-semibold">
              # <%= @active_member.username %>
            </div>
          <% end %>
        </div>
        <div class="flex-1 p-6"><%= render_messages(assigns) %></div>
        <div class="flex-none p-6">
          <.live_component
            id={:create_message}
            module={MessagesCreateLive}
            current_user={@current_user}
            active_member={@active_member}
            active_channel={@active_channel}
            live_action={@live_action}
          />
        </div>
      </div>
    </div>
    """
  end

  def render_messages(assigns) do
    ~H"""
    <ul>
      <li :for={message <- @messages} class="flex mb-4">
        <div class="w-10 h-10 rounded bg-gray-100 mr-4"></div>
        <div class="flex flex-col">
          <div class="flex">
            <span class="font-semibold leading-3"><%= message.sender.username %></span>
            <span class="ml-4 text-xs pb-0.5">
              <%= Calendar.strftime(message.inserted_at, "%I:%M %p") %>
            </span>
          </div>
          <div class="mt-1">
            <%= message.text %>
          </div>
        </div>
      </li>
    </ul>
    """
  end

  def render_members(assigns) do
    ~H"""
    <div x-data class="mt-8">
      <div class="font-semibold px-4 py-2">
        Direct messages
      </div>
      <ul class="mt-1">
        <li :for={member <- @members}>
          <.link
            patch={~p"/workspaces/#{@active_workspace}/members/#{member}"}
            class={"#{if assigns[:active_member] != nil and member.id == @active_member.id, do: "bg-zinc-300 text-slate-800", else: "hover:bg-zinc-700"} rounded px-4 py-0.5 w-full block hover:cursor-pointer"}
          >
            # <%= member.username %>
          </.link>
        </li>
      </ul>
      <div
        class="flex items-center hover:cursor-pointer hover:text-white mt-2 px-4"
        @click="$refs.members_dialog.showModal()"
      >
        <div class="bg-zinc-600 rounded h-4 w-4 mr-2 flex items-center justify-center">
          <.icon name="hero-plus" class="h-3 w-3 text-slate-400" />
        </div>
        <span>Add coworkers</span>
      </div>
      <dialog
        x-ref="members_dialog"
        class="p-4 shadow-xl w-1/2 backdrop:bg-gray-900 backdrop:bg-opacity-50 rounded"
      >
        <p>Members</p>
        <button @click="$refs.members_dialog.close()">Close</button>
      </dialog>
    </div>
    """
  end

  def render_channels(assigns) do
    ~H"""
    <div class="font-semibold mt-2 py-2 px-4">
      Channels
    </div>
    <ul class="mt-1">
      <li :for={channel <- @channels}>
        <.link
          patch={~p"/workspaces/#{@active_workspace}/channels/#{channel}"}
          class={"#{if @active_channel != nil and channel.id == @active_channel.id, do: "bg-zinc-300 text-slate-800", else: "hover:bg-zinc-700"} rounded px-4 py-0.5 w-full block hover:cursor-pointer"}
        >
          # <%= channel.name %>
        </.link>
      </li>
    </ul>
    <.live_component
      id={:create_channel}
      module={ChannelsCreateLive}
      active_workspace={@active_workspace}
      current_user={@current_user}
    />
    """
  end

  def render_workspaces(assigns) do
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
