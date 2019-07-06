defmodule TicketsystemWeb.Resolvers.Accounts do
  def list_users(_parent, _args, _resolution) do
    {:ok, Ticketsystem.Accounts.list_users()}
  end
end