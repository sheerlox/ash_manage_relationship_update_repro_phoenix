defmodule AshRepro.Repo do
  use Ecto.Repo,
    otp_app: :ash_repro,
    adapter: Ecto.Adapters.Postgres
end
