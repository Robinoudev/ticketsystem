defmodule TicketsystemWeb.Router do
  use TicketsystemWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TicketsystemWeb do
    pipe_through :api
  end
end
