defmodule TicketsystemWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation
  require IEx
  import AbsintheErrorPayload.Payload
  import_types AbsintheErrorPayload.ValidationMessageTypes

  alias TicketsystemWeb.Resolvers.Accounts, as: AccountsResolver

  object :user, description: "A user" do
    field :id, :id
    field :name, :string
    field :username, :string
    field :email, :string
    field :password_hash, :string
    field :token, :string
  end

  input_object :create_user_params, description: "Create a user" do
    field :name, non_null(:string), description: "Required name"
    field :username, non_null(:string), description: "Required username"
    field :email, non_null(:string), description: "Required email"
    field :password, non_null(:string), description: "Required password"
  end

  payload_object(:user_payload, :user)

  object :user_mutations do
    field :create_user, type: :user_payload, description: "Create a new user" do
      arg :user, :create_user_params
       IEx.pry
      resolve &AccountsResolver.create_user/3
      middleware &build_payload/2
    end
  end
end
