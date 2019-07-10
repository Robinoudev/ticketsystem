defmodule TicketsystemWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, :string
    field :username, :string
    field :email, :string
    field :password_hash, :string
    field :token, :string
  end
end
