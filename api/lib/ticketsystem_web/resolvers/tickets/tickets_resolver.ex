defmodule TicketsystemWeb.Resolvers.Tickets do
  @moduledoc """
  Tickets resolver
  """
  alias AbsintheErrorPayload.ValidationMessage
  alias Ticketsystem.Tickets

  def list_tickets(_parent, _args, %{context: %{current_user: _user}}) do
    {:ok, Tickets.list_tickets()}
  end

  def list_tickets(_parent, _args, _resolution) do
    {:ok,
     %ValidationMessage{
       field: :authorization,
       code: "denied",
       message: "not authorized to access this resource"
     }}
  end

  def insert_or_update_ticket(_parent, args, %{context: %{current_user: current_user}}) do
    result =
      case Tickets.insert_or_update_ticket(args.ticket, current_user) do
        {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
        {:ok, ticket} -> {:ok, ticket}
        nil -> {:ok, %ValidationMessage{field: :id, code: "not found", message: "does not exist"}}
      end

    result
  end

  def insert_or_update_ticket(_parent, _args, _resolution) do
    {:ok,
     %ValidationMessage{
       field: :authorization,
       code: "denied",
       message: "not authorized to access this resource"
     }}
  end
end
