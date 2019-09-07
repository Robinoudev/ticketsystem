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
    |> foreign_key_constraint(:issuer_id, name: :users_issuer_id_fkey)
    |> foreign_key_constraint(:handler_id, name: :users_handler_id_fkey)
    |> validate_length(:description, min: 4)
    |> validate_length(:title, min: 4)
    |> validate_inclusion(:status, ["draft", "submitted", "in_progress", "handled"])
    |> validate_inclusion(:priority, ["low", "normal", "high"])
  end
end
