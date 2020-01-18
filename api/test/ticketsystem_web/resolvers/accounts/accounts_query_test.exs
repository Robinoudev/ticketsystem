defmodule TicketsystemWeb.Resolvers.AccountsQueryTest do
  use TicketsystemWeb.ConnCase, async: true
  use Plug.Test
  import Ticketsystem.AbsintheHelpers

  describe "Accounts resolver queries" do
    setup do
      %{
        user: insert(:user_with_company, roles: [:superadmin]),
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
        """
      }
    end

    test "Returns unauthorized when not logged in", ctx do
      {:ok, %{data: %{"usersQuery" => result}}} =
        Absinthe.run(
          ctx.users_query,
          Schema
        )

      assert result["messages"] == [
               %{
                 "field" => "authorization",
                 "message" => "not authorized to access this resource"
               }
             ]
    end

    test "Returns users when current user is superadmin", ctx do
      {:ok, %{data: %{"usersQuery" => result}}} =
        Absinthe.run(
          ctx.users_query,
          Schema,
          context: context_for(ctx.user)
        )

      assert result["result"] == [%{"email" => ctx.user.email}]
    end

    test "Returns users when current user is admin", ctx do
      admin = insert(:user_with_company, roles: ["admin"])

      {:ok, %{data: %{"usersQuery" => result}}} =
        Absinthe.run(
          ctx.users_query,
          Schema,
          context: context_for(admin)
        )

      assert result["result"] == [%{"email" => ctx.user.email}, %{"email" => admin.email}]
    end

    test "Returns unauthorized when current user is no admin", ctx do
      user = insert(:user_with_company)

      {:ok, %{data: %{"usersQuery" => result}}} =
        Absinthe.run(
          ctx.users_query,
          Schema,
          context: context_for(user)
        )

      assert result["messages"] == [
               %{
                 "field" => "authorization",
                 "message" => "not authorized to access this resource"
               }
             ]
    end
  end
end
