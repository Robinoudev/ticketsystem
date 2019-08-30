defmodule TicketsystemWeb.Resolvers.AccountsQueryTest do
  use TicketsystemWeb.ConnCase, async: true
  use Plug.Test
  import Ticketsystem.AbsintheHelpers

  describe "Accounts resolver queries" do
    setup do
      %{
        user: insert(:user),
        users_query: """
          query Users {
            usersQuery {
              messages {
                field
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

    test "Returns unauthorized when not logged in", ctx do
      {:ok, %{data: %{"usersQuery" => result}}} = Absinthe.run(
        ctx.users_query,
        Schema
      )

      assert result["messages"] == [%{"field" => "authorization", "message" => "not authorized to access this resource"}]
    end

    test "Returns users when a valid context is provided", ctx do
      {:ok, %{data: %{"usersQuery" => result}}} = Absinthe.run(
        ctx.users_query,
        Schema,
        context: context_for(ctx.user)
      )

      assert result["result"] == [%{ "email" => ctx.user.email,}]
    end
  end
end
