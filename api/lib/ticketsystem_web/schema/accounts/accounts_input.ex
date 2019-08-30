defmodule TicketsystemWeb.Schema.AccountsInputs do
  @moduledoc """
  Definition of mutation inputs for Accounts context
  """
  use Absinthe.Schema.Notation
  import AbsintheErrorPayload.Payload

  alias TicketsystemWeb.Resolvers.Accounts, as: AccountsResolver

  object :user_input, description: "User input" do
    field :id, :id
    field :name, :string
    field :username, :string
    field :email, :string
    field :company_id, :id
    field :password_hash, :string
    field :token, :string
  end

  input_object :user_mutation_params, description: "Create a user" do
    field :name, non_null(:string), description: "Required name"
    field :username, non_null(:string), description: "Required username"
    field :email, non_null(:string), description: "Required email"
    field :password, non_null(:string), description: "Required password"
    field :company_id, non_null(:id), description: "Required company id"
  end

  payload_object(:user_payload, :user_input)

  object :user_mutation do
    field :user_mutation, type: :user_payload, description: "Create a new user" do
      arg(:user, :user_mutation_params)
      resolve(&AccountsResolver.create_user/3)
      middleware(&build_payload/2)
    end
  end

  input_object :login_params, description: "Login a user" do
    field :email, non_null(:string), description: "Email"
    field :password, non_null(:string), description: "Password"
  end

  payload_object(:login_payload, :user_input)

  object :login_mutation do
    field :login_mutation, type: :login_payload, description: "Login a user" do
      arg(:user, :login_params)
      resolve(&AccountsResolver.login/3)
      middleware(&build_payload/2)
    end
  end
end
