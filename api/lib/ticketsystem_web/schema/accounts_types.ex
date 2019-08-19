defmodule TicketsystemWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  alias TicketsystemWeb.Resolvers.Accounts, as: AccountsResolver

  object :user_type, description: "User query type" do
    field :id, :id
    field :name, :string
    field :username, :string
    field :email, :string
  end

  payload_object(:users_query_payload, list_of(:user_type))

  object :users_query do
    field :users_query, type: :users_query_payload, description: "query all users" do
      resolve &AccountsResolver.list_users/3
      middleware &build_payload/2
    end
  end
end
