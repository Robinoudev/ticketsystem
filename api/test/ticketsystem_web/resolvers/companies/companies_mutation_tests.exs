defmodule TicketsystemWeb.Resolvers.CompaniesMutationTest do
  use TicketsystemWeb.ConnCase, async: true
  use Plug.Test
  import Ticketsystem.AbsintheHelpers
  alias Ticketsystem.Companies

  describe "#companies_mutation" do
    setup do
      %{
        user: insert(:user),
        company_mutation: """
        mutation CompanyMutation ($company: CompanyMutationParams!) {
          companyMutation (company: $company) {
            messages {
              field
              message
            }
            result {
              name
            }
          }
        }
        """
      }
    end

    test "should create a company with valid attributes and context", ctx do
      variables = %{
        "company" => %{
          "name" => "valid name"
        }
      }

      {:ok, %{data: %{"companyMutation" => result}}} = Absinthe.run(
        ctx.company_mutation,
        Schema,
        context: context_for(ctx.user),
        variables: variables
      )

      new_company = Enum.at(Companies.list_companies(), -1)

      assert result["result"]["name"] == new_company.name
    end

    test "should validate the uniqueness of name", ctx do
      company = insert(:company)

      variables = %{
        "company" => %{
          "name" => company.name
        }
      }

      {:ok, %{data: %{"companyMutation" => result}}} = Absinthe.run(
        ctx.company_mutation,
        Schema,
        context: context_for(ctx.user),
        variables: variables
      )

      companies = Companies.list_companies()

      assert result["messages"] == [%{"field" => "name", "message" => "has already been taken"}]
      assert length(companies) == 1
      assert List.last(companies) == company
    end

    test "should update the name when a valid id is required and the new name is unique", ctx do
      company = insert(:company)

      variables = %{
        "company" => %{
          "id" => company.id,
          "name" => "updated name"
        }
      }

      {:ok, %{data: %{"companyMutation" => result}}} = Absinthe.run(
        ctx.company_mutation,
        Schema,
        context: context_for(ctx.user),
        variables: variables
      )

      companies = Companies.list_companies()

      assert result["result"]["name"] == "updated name"
      assert length(companies) == 1
      assert List.first(companies).name == "updated name"
    end

    test "should validate uniqueness of name when updating with a valid company_id", ctx do
      company = insert(:company)
      second_company = insert(:company)

      variables = %{
        "company" => %{
          "id" => company.id,
          "name" => second_company.name
        }
      }

      {:ok, %{data: %{"companyMutation" => result}}} = Absinthe.run(
        ctx.company_mutation,
        Schema,
        context: context_for(ctx.user),
        variables: variables
      )

      companies = Companies.list_companies()

      assert result["messages"] == [%{"field" => "name", "message" => "has already been taken"}]
      assert length(companies) == 2
      assert List.last(companies).name == second_company.name
    end
  end
end
