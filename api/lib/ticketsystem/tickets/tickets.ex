defmodule Ticketsystem.Tickets do
  @moduledoc """
  The Tickets context.
  """

  import Canada
  import Ecto.Query, warn: false
  alias AbsintheErrorPayload.ValidationMessage
  alias Ticketsystem.Repo

  alias Ticketsystem.Tickets.Ticket

  def list_tickets do
    Repo.all(Ticket)
  end

  def insert_or_update_ticket(attrs \\ {}, current_user) do
    ticket =
      case Map.fetch(attrs, :id) do
        {:ok, _value} -> Repo.get(Ticket, attrs.id) |> allow?(current_user)
        :error -> %Ticket{issuer_id: current_user.id}
      end

    case ticket do
      {:error, %ValidationMessage{} = message} -> {:error, message}
      _ -> ticket |> Ticket.changeset(attrs) |> Repo.insert_or_update()
    end
  end

  defp allow?(ticket, user) do
    cond do
      ticket && user |> can?(update(ticket)) ->
        ticket

      ticket ->
        {:error,
         %ValidationMessage{
           field: :authorization,
           code: "denied",
           message: "not authorized to access this resource"
         }}

      user ->
        {:error, %ValidationMessage{field: :id, code: "id", message: "resource not found"}}

      true ->
        {:error,
         %ValidationMessage{field: :unknown, code: "unknown", message: "unknown server error"}}
    end
  end
end
