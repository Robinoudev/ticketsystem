defmodule TicketsystemWeb.Schema.Enums do
  use Absinthe.Schema.Notation

  enum :role do
    value :superadmin
    value :admin
    value :handler
    value :regular
  end
end
