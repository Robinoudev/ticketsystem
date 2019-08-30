defmodule Ticketsystem.AbsintheHelpers do
  @moduledoc """
  Builds an authorized context for a given user to test queries/mutations
  """

  alias Ticketsystem.Context
  alias TicketsystemWeb.Resolvers.Accounts

  defmacro context_for(user) do
    quote do
      req_headers =
        Accounts.login(
          %{},
          %{user: %{email: unquote(user).email, password: "password"}},
          %{}
        )
        |> elem(1)

      conn =
        build_conn()
        |> put_req_header("authorization", "Bearer #{req_headers.token}")
        |> Context.call({})

      absinthe = conn.private[:absinthe]

      absinthe.context
    end
  end
end
