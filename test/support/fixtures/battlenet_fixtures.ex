defmodule MyPjt1.BattlenetFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MyPjt1.Battlenet` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        host: "some host",
        lock: true,
        password: "some password",
        status: 42,
        title: "some title"
      })
      |> MyPjt1.Battlenet.create_game()

    game
  end
end
