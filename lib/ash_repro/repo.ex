defmodule AshRepro.Repo do
  use AshPostgres.Repo,
    otp_app: :ash_repro

  def installed_extensions do
    [
      "citext",
      "uuid-ossp",
      "ash-functions"
    ]
  end
end
