defmodule ChatterWeb.MessagesCreateLive do
  use ChatterWeb, :live_component

  alias Chatter.Utils
  alias Chatter.Messages
  alias Chatter.Models.Message

  def mount(socket) do
    message_changeset = Messages.change_message(%Message{})

    {:ok,
     assign(socket,
       message_form: to_form(message_changeset)
     )}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@message_form}
        id="message_form"
        phx-submit="create_message"
        phx-target={@myself}
        phx-hook="MessageForm"
        id="message_form"
      >
        <.input
          field={@message_form[:text]}
          id="message_input"
          name="text"
          required
          autocomplete="off"
        />
        <div class="hidden">
          <.input name="reset_input" id="reset_input" value="" type="reset" />
        </div>
      </.simple_form>
    </div>
    """
  end

  def handle_event("create_message", %{"text" => text}, socket) do
    current_user = socket.assigns.current_user

    channel_id =
      if socket.assigns.active_channel != nil, do: socket.assigns.active_channel.id, else: nil

    member_id =
      if socket.assigns.active_member != nil, do: socket.assigns.active_member.id, else: nil

    %{
      sender_id: current_user.id,
      text: text
    }
    |> Utils.maybe_put(:recipient_id, member_id)
    |> Utils.maybe_put(:channel_id, channel_id)
    |> Messages.create_message()

    {:noreply, socket}
  end
end
