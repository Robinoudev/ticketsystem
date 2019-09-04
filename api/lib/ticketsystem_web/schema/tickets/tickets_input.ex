defmodule TicketsystemWeb.Schema.TicketsInput do
  @moduledoc """
  Definition of mutation inputs for Tickets context
  """
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  alias TicketsystemWeb.Resolvers.Tickets, as: TicketsResolver

  object :ticket_input, description: "Ticket input" do
    field :id, :id
    field :title, :string
    field :description, :string
    field :status, :string
    field :priority, :string
    field :issuer_id, :id
  end


  input_object :ticket_mutation_params, description: "Create or edit a ticket" do
    field :id, :id, description: "ID"
    field :title, non_null(:string), description: "Required title"
    field :description, non_null(:string), description: "Required description"
    field :status, :string, description: "Required description"
  end

  payload_object(:ticket_payload, :ticket_input)

  object :ticket_mutation do
    field :ticket_mutation, type: :ticket_payload, description: "Create or modify a ticket" do
      arg(:ticket, :ticket_mutation_params)
      resolve(&TicketsResolver.insert_or_update_ticket/3)
      middleware(&build_payload/2)
    end
  end
end
