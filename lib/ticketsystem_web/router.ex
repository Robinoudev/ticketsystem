defmodule TicketsystemWeb.Router do
  use TicketsystemWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: TicketsystemWeb.Schema

    forward "/", Absinthe.Plug,
      schema: TicketsystemWeb.Schema
  end
end
