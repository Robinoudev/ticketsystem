defmodule TicketsystemWeb.Schema do
  use Absinthe.Schema
  import_types AbsintheErrorPayload.ValidationMessageTypes

  import_types(TicketsystemWeb.Schema.AccountsTypes)
  import_types(TicketsystemWeb.Schema.AccountsInputs)

  query do
    import_fields :users_query
  end

  mutation do
    import_fields :user_mutations
    import_fields :login_mutation
  end
end
