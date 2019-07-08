# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ticketsystem,
  ecto_repos: [Ticketsystem.Repo]

config :ticketsystem, Ticketsystem.Guardian,
  # optional
  allowed_algos: ["HS512"],
  # optional
  verify_module: Guardian.JWT,
  issuer: "BlogAppGql",
  ttl: {30, :days},
  allowed_drift: 2000,
  # optional
  verify_issuer: true,
  # generated using: JOSE.JWK.generate_key({:oct, 16}) |> JOSE.JWK.to_map |> elem(1)
  secret_key: %{"k" => "6HqIpke1qsP6AEr2NVGbUg", "kty" => "oct"},
  serializer: Ticketsystem.Guardian

# Configures the endpoint
config :ticketsystem, TicketsystemWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VFXFFTP902fuRyLQy3bIyZw6nJ7OWu58Xe6pOIlCYsfB9vhuDZAEQ8Rc+NKjFkRX",
  render_errors: [view: TicketsystemWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Ticketsystem.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
