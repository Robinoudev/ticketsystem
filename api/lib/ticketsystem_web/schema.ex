defmodule TicketsystemWeb.Schema do
  use Absinthe.Schema

  alias TicketsystemWeb.Data

  import_types AbsintheErrorPayload.ValidationMessageTypes

  import_types(TicketsystemWeb.Schema.AccountsTypes)
  import_types(TicketsystemWeb.Schema.AccountsInputs)
  import_types(TicketsystemWeb.Schema.CompaniesType)
  import_types(TicketsystemWeb.Schema.CompaniesInput)

  query do
    import_fields :users_query
    import_fields :companies_query
  end

  mutation do
    import_fields :user_mutation
    import_fields :company_mutation
    import_fields :login_mutation
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Data, Data.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
