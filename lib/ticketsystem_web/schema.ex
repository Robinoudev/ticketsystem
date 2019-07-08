defmodule TicketsystemWeb.Schema do
  use Absinthe.Schema
  import_types(TicketsystemWeb.Schema.AccountsTypes)

  alias TicketsystemWeb.Resolvers

  query do
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve(&Resolvers.Accounts.list_users/3)
    end
  end

  mutation do
    @desc "Create a user"
    field :create_user, type: :user do
      arg(:name, non_null(:string))
      arg(:username, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.create_user/3)
    end

    @desc "Login a user"
    field :login, type: :user do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.login/3)
    end
  end
end
