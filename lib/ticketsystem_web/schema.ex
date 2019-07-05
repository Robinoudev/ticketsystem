defmodule TicketsystemWeb.Schema do
  use Absinthe.Schema
  import_types TicketsystemWeb.Schema.AccountsTypes

  alias TicketsystemWeb.Resolvers

  query do
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve &Resolvers.Accounts.list_users/3
    end
  end
end