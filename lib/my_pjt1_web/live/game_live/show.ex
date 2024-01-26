defmodule MyPjt1Web.GameLive.Show do
  use MyPjt1Web, :live_view_no_header_footer

  alias MyPjt1.Battlenet

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:game, Battlenet.get_game!(id))}
  end

  @impl true
  def handle_event("start", _params, socket) do
    {:noreply, assign(socket, is_ready: "true")}
  end

  def handle_event("ready", _params, socket) do
    {:noreply, assign(socket, is_ready: "false")}
  end

  defp page_title(:show), do: "Show Game"
  defp page_title(:edit), do: "Edit Game"
end
