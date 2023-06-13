defmodule ChatterWeb.HomeLive do
  use ChatterWeb, :live_view

  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl py-24 sm:px-6 sm:py-32 lg:px-8 text-gray-200">
      <div class="relative isolate overflow-hidden px-6 pt-16 sm:rounded-3xl sm:px-16 md:pt-24 lg:flex lg:gap-x-20 lg:px-24 lg:pt-0">
        <div class="mx-auto max-w-md text-center lg:mx-0 lg:flex-auto lg:py-32 lg:text-left">
          <h2 class="text-3xl font-bold tracking-tight text-white sm:text-4xl">
            Welcome to Chatter.<br />Start using our app today.
          </h2>
          <p class="mt-6 text-lg leading-8 text-gray-300">
            Connect the right people, find anything you need and automate the rest. That’s work in Chatter, your productivity platform.
          </p>
          <div class="mt-10 flex items-center justify-center gap-x-6 lg:justify-start">
            <.link
              href={~p"/workspaces"}
              class="rounded-md bg-white px-3.5 py-2.5 text-sm font-semibold text-gray-900 shadow-sm hover:bg-gray-100 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white"
            >
              Browse your workspaces
            </.link>
            <a href="#" class="text-sm font-semibold leading-6 text-white">
              Learn more <span aria-hidden="true">→</span>
            </a>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
