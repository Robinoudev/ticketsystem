defmodule TicketsystemWeb.Schema.TicketsType do
  @moduledoc """
  Definition of query fields for Tickets context
  """
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias TicketsystemWeb.Data
  alias TicketsystemWeb.Resolvers.Tickets, as: TicketsResolver

  object :ticket_type, description: "Tickets query type" do
    field :id, :id
    field :title, :string
    field :description, :string
    field :status, :string
    field :priority, :string
    field :handled_at, :string
    field :issuer, :user_type, resolve: dataloader(Data)
    field :handler, :user_type, resolve: dataloader(Data)
  end

  payload_object(:tickets_query_payload, list_of(:ticket_type))

  object :tickets_query do
    field :tickets_query, type: :tickets_query_payload, description: "query all tickets" do
      resolve(&TicketsResolver.list_tickets/3)
      middleware(&build_payload/2)
    end
  end
end
