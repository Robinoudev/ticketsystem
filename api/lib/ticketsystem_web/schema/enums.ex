defmodule TicketsystemWeb.Schema.Enums do
  @moduledoc """
  Enum module for GraphQL Enums
  """
  use Absinthe.Schema.Notation

  enum :role do
    value(:superadmin)
    value(:admin)
    value(:handler)
    value(:regular)
  end
end
