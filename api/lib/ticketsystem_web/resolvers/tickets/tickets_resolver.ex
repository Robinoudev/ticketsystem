defmodule TicketsystemWeb.Resolvers.Tickets do
  @moduledoc """
  Tickets resolver
  """
  alias AbsintheErrorPayload.ValidationMessage
  alias Ticketsystem.Tickets

  def list_tickets(_parent, _args, %{context: %{current_user: _user}}) do
    {:ok, Tickets.list_tickets()}
  end
end
