defmodule TicketsystemWeb.Resolvers.AccountsMutationTest do
  use TicketsystemWeb.ConnCase, async: true
  use Plug.Test

  import Ticketsystem.AbsintheHelpers

  alias Ticketsystem.Accounts
  alias TicketsystemWeb.Schema

  describe "Accounts resolver mutations" do
    setup do
      %{
        user: insert(:user_with_company, roles: ["superadmin"]),
        login_mutation: """
          mutation Login ($user: LoginParams) {
            loginMutation (user: $user) {
            messages {
                field
                message
              }
              result {
                email
                token
              }
            }
          }
        """,
        create_user_mutation: """
          mutation CreateUser ($params: UserMutationParams!) {
            userMutation (user: $params) {
              messages {
                field
                message
              }
              result {
                email
                name
                username
                companyId
              }
              successful
            }
          }
        """
      }
    end

    test "Can return a token on login", context do
      {:ok, result} =
        Absinthe.run(
          context.login_mutation,
          Schema,
          context: %{},
          variables: %{"user" => %{"email" => context.user.email, "password" => "password"}}
        )

      assert result.data["loginMutation"]["result"]["email"] == context.user.email
      assert result.data["loginMutation"]["result"]["token"] != nil
    end

    test "Checks for valid credentials", context do
      {:ok, %{data: %{"loginMutation" => result}}} =
        Absinthe.run(
          context.login_mutation,
          Schema,
          context: %{},
          variables: %{"user" => %{"email" => context.user.email, "password" => "wrongpassword"}}
        )

      assert result["result"] == nil

      assert result["messages"] == [
               %{"field" => "credentials", "message" => "invalid password provided"}
             ]
    end

    test "Checks if user exists on login", context do
      {:ok, %{data: %{"loginMutation" => result}}} =
        Absinthe.run(
          context.login_mutation,
          Schema,
          context: %{},
          variables: %{
            "user" => %{"email" => "userthatdoesnotexist@email.com", "password" => "password"}
          }
        )

      assert result["result"] == nil

      assert result["messages"] == [
               %{"field" => "credentials", "message" => "no user with given email"}
             ]
    end

    test "Can create a user with valid input object", context do
      company = insert(:company)

      {:ok, %{data: %{"userMutation" => result}}} =
        Absinthe.run(
          context.create_user_mutation,
          Schema,
          variables: %{
            "params" => %{
              "email" => "test@email.com",
              "password" => "password",
              "name" => "name",
              "username" => "username",
              "companyId" => company.id
            }
          },
          context: context_for(context.user)
        )

      users = Accounts.list_users()
      new_user = List.last(users)

      assert result["result"] ==
               %{
                 "email" => new_user.email,
                 "name" => new_user.name,
                 "username" => new_user.username,
                 "companyId" => "#{company.id}"
               }

      assert length(users) == 2
    end

    test "Validates uniqueness of username", context do
      company = insert(:company)

      {:ok, result} =
        Absinthe.run(
          context.create_user_mutation,
          Schema,
          context: context_for(context.user),
          variables: %{
            "params" => %{
              "email" => "test@email.com",
              "password" => "password",
              "name" => "name",
              "username" => context.user.username,
              "companyId" => company.id
            }
          }
        )

      assert result.data["userMutation"]["messages"] == [
               %{
                 "field" => "username",
                 "message" => "has already been taken"
               }
             ]

      users = Accounts.list_users()
      assert length(users) == 1
    end

    test "Validates uniqueness of email", context do
      company = insert(:company)

      {:ok, result} =
        Absinthe.run(
          context.create_user_mutation,
          Schema,
          context: context_for(context.user),
          variables: %{
            "params" => %{
              "email" => context.user.email,
              "password" => "password",
              "name" => "name",
              "username" => "someusername",
              "companyId" => company.id
            }
          }
        )

      assert result.data["userMutation"]["messages"] == [
               %{
                 "field" => "email",
                 "message" => "has already been taken"
               }
             ]

      users = Accounts.list_users()
      assert length(users) == 1
    end
  end
end
