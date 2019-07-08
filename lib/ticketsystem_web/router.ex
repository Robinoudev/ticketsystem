defmodule TicketsystemWeb.Router do
  use TicketsystemWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Ticketsystem.Context
  end

  scope "/" do
    pipe_through [:api, :auth]

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: TicketsystemWeb.Schema

    forward "/", Absinthe.Plug, schema: TicketsystemWeb.Schema
  end
end
