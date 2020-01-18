defmodule TicketsystemWeb.Resolvers.Tickets do
  @moduledoc """
  Tickets resolver
  """
  alias AbsintheErrorPayload.ValidationMessage
  alias Ticketsystem.Tickets

  def list_tickets(_parent, _args, %{context: %{current_user: user}}) do
    case Tickets.list_tickets(user) do
      {:error, %ValidationMessage{} = message} -> {:ok, message}
      {:ok, tickets} -> {:ok, tickets}
    end
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
        {:error, %ValidationMessage{} = message} -> {:ok, message}
        {:ok, ticket} -> {:ok, ticket}
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
