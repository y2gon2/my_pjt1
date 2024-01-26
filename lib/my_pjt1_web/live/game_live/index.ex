defmodule MyPjt1Web.GameLive.Index do
  use MyPjt1Web, :live_view

  require Logger

  alias MyPjt1.Battlenet
  alias MyPjt1.Battlenet.Game

  @impl true
  def mount(_params, _session, socket) do
    Logger.info(socket: socket.assigns.current_user.email)

    {:ok, stream(socket, :games, Battlenet.list_games())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Game")
    |> assign(:game, Battlenet.get_game!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Game")
    |> assign(:game, %Game{password: "", lock: "false", status: "1", title: "", host: socket.assigns.current_user.email})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Games")
    |> assign(:game, nil)
  end

  @impl true
  def handle_info({MyPjt1Web.GameLive.FormComponent, {:saved, game}}, socket) do
    {:noreply, stream_insert(socket, :games, game)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    game = Battlenet.get_game!(id)
    {:ok, _} = Battlenet.delete_game(game)

    {:noreply, stream_delete(socket, :games, game)}
  end
end
