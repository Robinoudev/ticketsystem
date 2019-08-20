defmodule TicketsystemWeb.Schema.CompaniesInput do
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  alias TicketsystemWeb.Resolvers.Companies, as: CompaniesResolver

  object :company_input, description: "Company input" do
    field :name, :string
  end

  input_object :company_mutation_params, description: "Create a company" do
    field :name, non_null(:string), description: "Required name"
  end

  payload_object(:company_payload, :company_input)

  object :company_mutation do
    field :company_mutation, type: :company_payload, description: "Create a company" do
      arg :company, :company_mutation_params
      resolve &CompaniesResolver.mutate_company/3
      middleware &build_payload/2
    end
  end
end
