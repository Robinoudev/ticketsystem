defmodule Ticketsystem.Tickets do
  @moduledoc """
  The Tickets context.
  """

  import Ecto.Query, warn: false
  alias Ticketsystem.Repo

  alias Ticketsystem.Tickets.Ticket

  def list_tickets do
    Repo.all(Ticket)
  end

  def get_ticket!(id), do: Repo.get!(Ticket, id)

  def insert_or_update_ticket(attrs \\ {}, current_user) do
    ticket =
      case Map.fetch(attrs, :id) do
        {:ok, _value} -> Repo.get(Ticket, attrs.id)
        :error -> %Ticket{issuer_id: current_user.id}
      end

    case ticket do
      nil -> nil
      _ -> ticket |> Ticket.changeset(attrs) |> Repo.insert_or_update()
    end
  end
end
