defmodule MyPjt1.BattlenetTest do
  use MyPjt1.DataCase

  alias MyPjt1.Battlenet

  describe "games" do
    alias MyPjt1.Battlenet.Game

    import MyPjt1.BattlenetFixtures

    @invalid_attrs %{host: nil, lock: nil, password: nil, status: nil, title: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Battlenet.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Battlenet.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{host: "some host", lock: true, password: "some password", status: 42, title: "some title"}

      assert {:ok, %Game{} = game} = Battlenet.create_game(valid_attrs)
      assert game.host == "some host"
      assert game.lock == true
      assert game.password == "some password"
      assert game.status == 42
      assert game.title == "some title"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Battlenet.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{host: "some updated host", lock: false, password: "some updated password", status: 43, title: "some updated title"}

      assert {:ok, %Game{} = game} = Battlenet.update_game(game, update_attrs)
      assert game.host == "some updated host"
      assert game.lock == false
      assert game.password == "some updated password"
      assert game.status == 43
      assert game.title == "some updated title"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Battlenet.update_game(game, @invalid_attrs)
      assert game == Battlenet.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Battlenet.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Battlenet.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Battlenet.change_game(game)
    end
  end
end
