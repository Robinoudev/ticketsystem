defmodule Ticketsystem.Tickets.Ticket do
  @moduledoc """
  Model definition of a ticket
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Ticketsystem.Accounts.User

  schema "tickets" do
    field :description, :string
    field :status, :string
    field :title, :string
    field :priority, :string
    field :handled_at, :naive_datetime

    belongs_to :issuer, User
    belongs_to :handler, User

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [
      :title,
      :description,
      :status,
      :priority,
      :handled_at,
      :issuer_id,
      :handler_id
    ])
    |> validate_required([:title, :description, :issuer_id])
  end
end
