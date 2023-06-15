defmodule ChatterWeb.Workspace.Messages do
  use ChatterWeb, :html

  def messages(assigns) do
    ~H"""
    <ul>
      <li :for={message <- @messages} class="flex mb-4">
        <div class="w-10 h-10 rounded bg-gray-500 mr-4"></div>
        <div class="flex flex-col">
          <div class="flex items-baseline">
            <span class="font-semibold leading-3"><%= message.sender.username %></span>
            <span class="ml-4 text-xs">
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
end
