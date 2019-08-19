defmodule Ticketsystem.Repo do
  use Ecto.Repo,
    otp_app: :ticketsystem,
    adapter: Ecto.Adapters.Postgres
end
