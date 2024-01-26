defmodule MyPjt1.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :title, :string
      add :password, :string
      add :lock, :boolean, default: false, null: false
      add :host, :string
      add :status, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
