defmodule TicketsystemWeb.Resolvers.CompaniesQueryTest do
  use TicketsystemWeb.ConnCase, async: true
  use Plug.Test
  import Ticketsystem.AbsintheHelpers

  describe "Companies resolver queries" do
    setup do
      %{
        user: insert(:user),
        company: insert(:company),
        companies_query: """
          query Companies {
            companiesQuery {
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
      {:ok, result} = Absinthe.run(
        ctx.companies_query,
        Schema
      )

      assert result.data["companiesQuery"] == nil
      assert List.first(result.errors).message == "Access denied"
    end

    test "Returns companies when a valid context is provided", ctx do
      {:ok, %{data: %{"companiesQuery" => result}}} = Absinthe.run(
        ctx.companies_query,
        Schema,
        context: context_for(ctx.user)
      )

      assert result["result"] == [
        %{
          "name" => ctx.company.name,
          # "id" => "#{ctx.company.id}",
          "id" => to_string(ctx.company.id),
          "users" => []
        }
      ]
    end
  end
end
