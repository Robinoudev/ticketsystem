defmodule TicketsystemWeb.Resolvers.CompaniesMutationTest do
  use TicketsystemWeb.ConnCase, async: true
  use Plug.Test
  import Ticketsystem.AbsintheHelpers
  alias Ticketsystem.Companies
  alias Ticketsystem.Companies.Company
  alias Ticketsystem.Repo

  @company_mutation """
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

  describe "Companies resolver superadmin mutations" do
    @describetag :superadmin

    setup do
      %{
        user: insert(:user_with_company, roles: [:superadmin])
      }
    end

    test "should create a company with valid attributes and context", ctx do
      variables = %{
        "company" => %{
          "name" => "valid name"
        }
      }

      {:ok, %{data: %{"companyMutation" => result}}} =
        Absinthe.run(
          @company_mutation,
          Schema,
          context: context_for(ctx.user),
          variables: variables
        )

      {:ok, companies = companies} = Companies.list_companies(ctx.user)
      new_company = companies |> Enum.at(-1)

      assert result["result"]["name"] == new_company.name
      assert length(companies) == 2
    end

    test "should validate the uniqueness of name", ctx do
      company = insert(:company)

      variables = %{
        "company" => %{
          "name" => company.name
        }
      }

      {:ok, %{data: %{"companyMutation" => result}}} =
        Absinthe.run(
          @company_mutation,
          Schema,
          context: context_for(ctx.user),
          variables: variables
        )

      {:ok, companies = companies} = Companies.list_companies(ctx.user)

      assert result["messages"] == [%{"field" => "name", "message" => "has already been taken"}]
      assert length(companies) == 2
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

      {:ok, %{data: %{"companyMutation" => result}}} =
        Absinthe.run(
          @company_mutation,
          Schema,
          context: context_for(ctx.user),
          variables: variables
        )

      {:ok, companies = companies} = Companies.list_companies(ctx.user)

      assert result["result"]["name"] == "updated name"
      assert length(companies) == 2
      assert List.last(companies).name == "updated name"
    end

    test "should validate uniqueness of name when updating with a valid company_id", ctx do
      company = insert(:company)

      variables = %{
        "company" => %{
          "id" => ctx.user.company.id,
          "name" => company.name
        }
      }

      {:ok, %{data: %{"companyMutation" => result}}} =
        Absinthe.run(
          @company_mutation,
          Schema,
          context: context_for(ctx.user),
          variables: variables
        )

      {:ok, companies = companies} = Companies.list_companies(ctx.user)

      assert result["messages"] == [%{"field" => "name", "message" => "has already been taken"}]
      assert length(companies) == 2
      assert List.first(companies).name != company.name
    end

    test "should throw company not found error when id doesn't exist", ctx do
      variables = %{
        "company" => %{
          "id" => "1234",
          "name" => "Name"
        }
      }

      {:ok, %{data: %{"companyMutation" => result}}} =
        Absinthe.run(
          @company_mutation,
          Schema,
          context: context_for(ctx.user),
          variables: variables
        )

      {:ok, companies = companies} = Companies.list_companies(ctx.user)

      assert result["messages"] == [%{"field" => "id", "message" => "resource not found"}]
      assert length(companies) == 1
    end
  end

  describe "Companies resolver admin mutations" do
    @describetag :admin

    setup do
      %{
        user: insert(:user_with_company, roles: [:admin])
      }
    end

    test "cannot create a company", ctx do
      variables = %{
        "company" => %{
          "name" => "New company"
        }
      }

      {:ok, %{data: %{"companyMutation" => result}}} =
        Absinthe.run(
          @company_mutation,
          Schema,
          context: context_for(ctx.user),
          variables: variables
        )

      assert result["messages"] == [
               %{
                 "field" => "authorization",
                 "message" => "not authorized to access this resource"
               }
             ]

      assert length(Repo.all(Company)) == 1
    end

    test "can update its own company", ctx do
      variables = %{
        "company" => %{
          "id" => "#{ctx.user.company_id}",
          "name" => "Changed"
        }
      }

      {:ok, %{data: %{"companyMutation" => result}}} =
        Absinthe.run(
          @company_mutation,
          Schema,
          context: context_for(ctx.user),
          variables: variables
        )

      companies = Repo.all(Company)

      assert result["result"]["name"] == "Changed"
      assert List.last(companies).name == "Changed"
      assert length(companies) == 1
    end

    test "cannot update an other company", ctx do
      decoy_company = insert(:company)

      variables = %{
        "company" => %{
          "id" => "#{decoy_company.id}",
          "name" => "Changed"
        }
      }

      {:ok, %{data: %{"companyMutation" => result}}} =
        Absinthe.run(
          @company_mutation,
          Schema,
          context: context_for(ctx.user),
          variables: variables
        )

      assert result["messages"] == [
               %{
                 "field" => "authorization",
                 "message" => "not authorized to access this resource"
               }
             ]

      assert length(Repo.all(Company)) == 2
      assert List.last(Repo.all(Company)).name == decoy_company.name
    end
  end
end
