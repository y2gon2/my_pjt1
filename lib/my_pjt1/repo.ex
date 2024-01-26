defmodule MyPjt1.Repo do
  use Ecto.Repo,
    otp_app: :my_pjt1,
    adapter: Ecto.Adapters.Postgres
end
