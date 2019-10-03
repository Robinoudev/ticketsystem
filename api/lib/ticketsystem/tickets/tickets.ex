defmodule Ticketsystem.Tickets do
  @moduledoc """
  The Tickets context.
  """

  import Canada
  import Ecto.Query, warn: false
  alias AbsintheErrorPayload.ValidationMessage
  alias Ticketsystem.Allow
  alias Ticketsystem.Repo
  require Ticketsystem.Allow

  alias Ticketsystem.Tickets.Ticket

  def list_tickets do
    Repo.all(Ticket)
  end

  def insert_or_update_ticket(attrs \\ %{}, current_user) do
    ticket =
      case Map.fetch(attrs, :id) do
        {:ok, _value} -> Repo.get(Ticket, attrs.id) |> Allow.authorize(:update, current_user)
        :error -> %Ticket{issuer_id: current_user.id} |> Allow.authorize(:create, current_user)
      end

    case ticket do
      {:error, %ValidationMessage{} = message} -> {:error, message}
      _ -> ticket |> Ticket.changeset(attrs) |> Repo.insert_or_update()
    end
  end
end
