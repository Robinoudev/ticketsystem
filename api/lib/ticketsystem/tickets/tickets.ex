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

  @doc """
  Returns list of all tickets
  """
  def list_tickets(current_user) do
    case Allow.authorize(Ticket, :read, current_user) do
      {:error, %ValidationMessage{} = message} -> {:error, message}
      Ticket -> {:ok, Repo.all(Ticket)}
    end
  end

  @doc """
  Gets the ticket from `attrs.id` if any and updates otherwise inserts new Ticket
  """
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
