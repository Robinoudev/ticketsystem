defmodule Ticketsystem.AbsintheHelpers do
  defmacro context_for(user) do
    quote do
      req_headers =
        TicketsystemWeb.Resolvers.Accounts.login(
          %{},
          %{user: %{email: unquote(user).email, password: "password"}},
          %{}
        )
        |> elem(1)

      conn =
        build_conn()
        |> put_req_header("authorization", "Bearer #{req_headers.token}")
        |> Ticketsystem.Context.call({})

      absinthe = conn.private[:absinthe]

      absinthe.context
    end
  end
end
