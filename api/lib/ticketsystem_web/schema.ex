defmodule TicketsystemWeb.Schema do
  use Absinthe.Schema
  import_types(TicketsystemWeb.Schema.AccountsTypes)

  query do
    import_fields :users_query
  end

  mutation do
    import_fields :user_mutations
    import_fields :login_mutation
  end
end
