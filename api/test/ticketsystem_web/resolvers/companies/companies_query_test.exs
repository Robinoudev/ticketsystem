defmodule TicketsystemWeb.Resolvers.CompaniesQueryTest do
  use TicketsystemWeb.ConnCase, async: true
  use Plug.Test
  import Ticketsystem.AbsintheHelpers

  describe "Companies resolver queries" do
    setup do
      %{
        user: insert(:user_with_company),
        company: insert(:company),
        companies_query: """
          query Companies {
            companiesQuery {
              messages {
                field
                message
              }
              result {
                id
                name
                users {
                  id
                  email
                  name
                }
              }
            }
          }
        """
      }
    end

    test "Returns unauthorized when not logged in", ctx do
      {:ok, %{data: %{"companiesQuery" => result}}} =
        Absinthe.run(
          ctx.companies_query,
          Schema
        )

      assert result["messages"] == [
               %{
                 "field" => "authorization",
                 "message" => "not authorized to access this resource"
               }
             ]
    end

    test "Returns companies when a valid context is provided", ctx do
      {:ok, %{data: %{"companiesQuery" => result}}} =
        Absinthe.run(
          ctx.companies_query,
          Schema,
          context: context_for(ctx.user)
        )

      assert result["result"] == [
               %{
                 "name" => ctx.user.company.name,
                 "id" => to_string(ctx.user.company.id),
                 "users" => [
                   %{
                     "email" => ctx.user.email,
                     "name" => ctx.user.name,
                     "id" => to_string(ctx.user.id)
                   }
                 ]
               },
               %{
                 "name" => ctx.company.name,
                 "id" => to_string(ctx.company.id),
                 "users" => []
               }
             ]
    end
  end
end
