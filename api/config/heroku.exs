use Mix.Config

config :ticketsystem, TicketsystemWeb.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  url: [host: System.get_env("HEROKU_APP_NAME") <> ".herokuapp.com"]

config :logger, level: :info

database_url = System.get_env("DATABASE_URL") || ""

config :ticketsystem, Ticketsystem.Repo, url: database_url
