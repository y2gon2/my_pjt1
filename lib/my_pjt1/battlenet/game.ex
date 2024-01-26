defmodule MyPjt1.Battlenet.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :host, :string
    field :lock, :boolean, default: false
    field :password, :string
    field :status, :integer
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    IO.inspect(attrs, label: "attrssss")

    if attrs == %{} || attrs[:lock] == "true" do
      game
      |> cast(attrs, [:title, :password, :lock, :host, :status])
      |> validate_required([:title, :password, :lock, :host, :status])
    else
      game
      |> cast(attrs, [:title, :password, :lock, :host, :status])
      |> validate_required([:title, :lock, :host, :status])
    end
  end
end
