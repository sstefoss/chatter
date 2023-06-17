defmodule ChatterWeb.WorkspacesViewLive do
  use ChatterWeb, :live_view

  alias Chatter.Workspaces
  alias Chatter.Channels
  alias Chatter.Members
  alias Chatter.Messages
  alias Chatter.Invitations
  alias Chatter.Models.Message
  alias Chatter.Models.Channel
  alias Chatter.Models.Member

  alias ChatterWeb.ChannelsCreateLive
  alias ChatterWeb.MessagesCreateLive
  alias ChatterWeb.InvitationsCreateLive

  import ChatterWeb.Workspace.Members
  import ChatterWeb.Workspace.Channels
  import ChatterWeb.Workspace.Messages
  import ChatterWeb.Workspace.Workspaces

  def mount(_, _, socket) do
    if connected?(socket) do
      Channels.subscribe()
      Workspaces.subscribe()
      Members.subscribe()
      Messages.subscribe()
      Invitations.subscribe()
    end

    current_user = socket.assigns.current_user

    workspaces = Workspaces.list_workspaces_for_user(current_user)
    active_workspace = hd(workspaces)

    members = Workspaces.list_members_for_workspace(active_workspace)

    channels = Workspaces.list_channels_for_workspace(active_workspace)
    active_channel = hd(channels)

    invitations = Workspaces.list_invitations_for_workspace(active_workspace)

    messages = Messages.list_messages_for_channel(active_channel)

    {:ok,
     assign(socket,
       workspaces: workspaces,
       active_workspace: active_workspace,
       members: members,
       active_member: nil,
       channels: channels,
       active_channel: active_channel,
       messages: messages,
       invitations: invitations,
       active_invitation: nil
     )}
  end

  def handle_params(%{"channel_id" => channel_id, "id" => _}, _uri, socket) do
    channel = Channels.get_channel(channel_id)
    messages = Messages.list_messages_for_channel(channel)

    {:noreply,
     assign(socket,
       active_channel: channel,
       active_member: nil,
       messages: messages,
       active_invitation: nil
     )}
  end

  def handle_params(%{"member_id" => member_id, "id" => _}, _uri, socket) do
    member = Members.get_member(member_id)
    {:noreply, assign(socket, active_channel: nil, active_member: member, active_invitation: nil)}
  end

  def handle_params(%{"invitation_id" => invitation_id, "id" => _}, _uri, socket) do
    invitation = Invitations.get_invitation_by_id(invitation_id)

    {:noreply,
     assign(socket, active_channel: nil, active_member: nil, active_invitation: invitation)}
  end

  def handle_params(_, _, socket), do: {:noreply, socket}

  def handle_info({:message_created, message}, socket) do
    live_action = socket.assigns.live_action
    active_channel = socket.assigns.active_channel
    active_member = socket.assigns.active_member

    handle_message_created(message, active_channel, active_member, socket)
  end

  # message was sent to channel
  def handle_message_created(%Message{recipient_id: nil} = message, %Channel{} = active_channel, _, socket) do
    case message.channel_id == active_channel.id do
      true ->
        messages = Messages.list_messages_for_channel(active_channel)
        {:noreply, assign(socket, messages: messages)}

      false -> {:noreply, socket}
    end
  end
  def handle_message_created(%Message{recipient_id: nil} = message, nil, _, socket), do: {:noreply, socket}

  # message was sent to user
  def handle_message_created(%Message{channel_id: nil} = message, _, %Member{} = active_member, socket) do
    {:noreply, socket}
  end
  def handle_message_created(%Message{channel_id: nil} = message, _, nil, socket), do: {:noreply, socket}

  def handle_info({:channel_created, channel}, socket) do
    active_workspace = socket.assigns.active_workspace
    channels = Workspaces.list_channels_for_workspace(active_workspace)

    socket =
      socket
      |> push_patch(to: ~p"/workspaces/#{active_workspace}/channels/#{channel}")
      |> assign(:active_channel, channel)
      |> assign(:channels, channels)

    {:noreply, socket}
  end

  def handle_info({:invitation_created, invitation}, socket) do
    active_workspace = socket.assigns.active_workspace
    invitations = Workspaces.list_invitations_for_workspace(active_workspace)

    socket =
      socket
      |> push_patch(to: ~p"/workspaces/#{active_workspace}/invitations/#{invitation}")
      |> assign(:active_invitation, invitation)
      |> assign(:invitations, invitations)

    {:noreply, socket}
  end

  def handle_info(_, socket), do: {:noreply, socket}

  def render(assigns) do
    ~H"""
    <div class="flex h-full border border-zinc-700">
      <aside class="w-16 h-full py-4 bg-zinc-900 flex flex-col items-center">
        <.workspaces workspaces={@workspaces} active_workspace={@active_workspace} />
      </aside>
      <div class="w-60 border-x border-zinc-700 text-gray-300 overflow-auto">
        <div class="font-semibold py-2 px-6 text-xl border-b border-zinc-700 text-white sticky top-0 bg-zinc-900">
          <%= @active_workspace.name %>
        </div>
        <div class="px-2">
          <.channels channels={@channels} active_channel={@active_channel} active_workspace={@active_workspace} />
          <.live_component
            id={:create_channel}
            module={ChannelsCreateLive}
            active_workspace={@active_workspace}
            current_user={@current_user}
          />
        </div>
        <div class="px-2">
          <.members
            active_member={@active_member}
            active_workspace={@active_workspace}
            members={@members}
            invitations={@invitations}
            active_invitation={@active_invitation}
          />
          <.live_component
            id={:create_invitations}
            module={InvitationsCreateLive}
            active_workspace={@active_workspace}
            current_user={@current_user}
          />
        </div>
      </div>
      <div class="flex flex-col flex-1">
        <div class="flex-none py-2 px-6 border-b border-zinc-700 flex items-center">
          <%= if @live_action == :channels do %>
            <div class="text-gray-200 text-lg font-semibold">
              # <%= @active_channel.name %>
            </div>
            <div class="text-gray-400 ml-6 text-sm">
              <%= @active_channel.description %>
            </div>
          <% end %>
          <%= if @live_action == :members do %>
            <div class="text-gray-200 text-lg font-semibold">
              <%= @active_member.username %>
            </div>
          <% end %>
          <%= if @live_action == :invitations do %>
            <div class="text-gray-200 text-lg font-semibold">
              <%= @active_invitation.email %>
            </div>
          <% end %>
        </div>
        <div class="flex-1 p-6 overflow-auto"><.messages messages={@messages} /></div>
        <div class="flex-none p-6">
          <.live_component
            id={:create_message}
            module={MessagesCreateLive}
            current_user={@current_user}
            active_workspace={@active_workspace}
            active_member={@active_member}
            active_channel={@active_channel}
            live_action={@live_action}
          />
        </div>
      </div>
    </div>
    """
  end
end
