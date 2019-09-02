defmodule TicketsystemWeb.Schema.AccountsTypes do
  @moduledoc """
  Definition of query fields for Accounts context
  """
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias TicketsystemWeb.Data
  alias TicketsystemWeb.Resolvers.Accounts, as: AccountsResolver

  object :user_type, description: "User query type" do
    field :id, :id
    field :name, :string
    field :username, :string
    field :email, :string
    field :company, :company_type, resolve: dataloader(Data)
    field :issued_tickets, list_of(:ticket_type), resolve: dataloader(Data)
    field :handled_tickets, list_of(:ticket_type), resolve: dataloader(Data)
  end

  payload_object(:users_query_payload, list_of(:user_type))

  object :users_query do
    field :users_query, type: :users_query_payload, description: "query all users of a company" do
      resolve(&AccountsResolver.list_users/3)
      middleware(&build_payload/2)
    end
  end
end
