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
    import_fields :user_mutations

    @desc "Login a user"
    field :login, type: :user do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.login/3)
    end
  end
end
