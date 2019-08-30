defmodule TicketsystemWeb.Schema.CompaniesType do
  @moduledoc """
  Definition of query fields for Companies context
  """
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload
  import Absinthe.Resolution.Helpers, only: [dataloader: 3]

  alias TicketsystemWeb.Data
  alias TicketsystemWeb.Resolvers.Companies, as: CompaniesResolver

  object :company_type, description: "Company query type" do
    field :id, :id
    field :name, :string
    field :users, list_of(:user_type), resolve: dataloader(Data, :users, args: %{order_by: :id})
  end

  payload_object(:companies_query_payload, list_of(:company_type))

  object :companies_query do
    field :companies_query, type: :companies_query_payload, description: "query companies" do
      resolve(&CompaniesResolver.list_companies/3)
      middleware(&build_payload/2)
    end
  end
end
