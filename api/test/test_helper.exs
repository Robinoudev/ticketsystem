{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Ticketsystem.Repo, :manual)
Absinthe.Test.prime(TicketsystemWeb.Schema)
