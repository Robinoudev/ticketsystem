defmodule TicketsystemWeb.Resolvers.AccountsQueryTest do
  use TicketsystemWeb.ConnCase, async: true
  use Plug.Test
  import Ticketsystem.Factory
  alias TicketsystemWeb.Schema

  describe "Accounts resolver queries" do
    @unauthorized_context %{}

    setup do
      %{
        user: insert(:user),
        users_query: """
          query Users {
            usersQuery {
              messages {
                message
              }
              result {
                email
              }
            }
          }
        """,
      }
    end

    test "Returns unauthorized not logged in", context do
      {:ok, result} = Absinthe.run(
        context.users_query,
        Schema,
        context: @unauthorized_context
      )

      assert result.data["usersQuery"] == nil
      assert Enum.at(result.errors, 0).message == "Access denied"
    end

    test "Returns users when a valid context is provided", context do
      req_headers =
        TicketsystemWeb.Resolvers.Accounts.login(
          %{},
          %{user: %{email: context.user.email, password: "password"}},
          %{}
        )
        |> elem(1)

      conn =
        build_conn()
        |> put_req_header("authorization", "Bearer #{req_headers.token}")
        |> Ticketsystem.Context.call({})

      absinthe = conn.private[:absinthe]

      {:ok, result} = Absinthe.run(
        context.users_query,
        Schema,
        context: absinthe.context
      )

      assert result.data["usersQuery"]["result"] == [%{ "email" => context.user.email,}]
    end
  end
end
