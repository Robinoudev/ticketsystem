defmodule TicketsystemWeb.Schema do
  @moduledoc """
  Global GraphQL Schema for the Ticketsystem API
  """
  use Absinthe.Schema

  alias TicketsystemWeb.Data

  import_types(AbsintheErrorPayload.ValidationMessageTypes)
  import_types(TicketsystemWeb.Schema.Enums)

  import_types(TicketsystemWeb.Schema.AccountsType)
  import_types(TicketsystemWeb.Schema.AccountsInput)
  import_types(TicketsystemWeb.Schema.CompaniesType)
  import_types(TicketsystemWeb.Schema.CompaniesInput)
  import_types(TicketsystemWeb.Schema.TicketsType)
  import_types(TicketsystemWeb.Schema.TicketsInput)

  query do
    import_fields(:users_query)
    import_fields(:companies_query)
    import_fields(:tickets_query)
  end

  mutation do
    import_fields(:user_mutation)
    import_fields(:company_mutation)
    import_fields(:login_mutation)
    import_fields(:ticket_mutation)
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
