defmodule TicketsystemWeb.Resolvers.AccountsTest do
  use TicketsystemWeb.ConnCase, async: true
  use Plug.Test
  import Ticketsystem.Factory
  alias TicketsystemWeb.Schema

  describe "Accounts resolver" do
    @unauthorized_context %{}

    setup do
      %{user: insert(:user)}
    end

    test "Can return a token on login", context do
      mutation = """
      mutation Login {
        loginUser (user: {
          email: "#{context.user.email}",
          password: "password"
        }) {
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
      """

      {:ok, result} = Absinthe.run(
        mutation,
        Schema,
        context: @unauthorized_context
      )

      assert result.data["loginUser"]["result"]["email"] == context.user.email
      assert result.data["loginUser"]["result"]["token"] != nil
    end

    test "Checks for valid credentials", context do
      mutation = """
      mutation Login {
        loginUser (user: {
          email: "#{context.user.email}",
          password: "wrongpassword"
        }) {
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
      """

      {:ok, result} = Absinthe.run(
        mutation,
        Schema,
        context: @unauthorized_context
      )

      assert result.data["loginUser"] == nil
      assert Enum.at(result.errors, 0).message == "Invalid credentials"
    end

    test "Checks if user exists on login" do
      mutation = """
      mutation Login {
        loginUser (user: {
          email: "userthatdoesnotexist@email.com",
          password: "password"
        }) {
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
      """

      {:ok, result} = Absinthe.run(
        mutation,
        Schema,
        context: @unauthorized_context
      )

      assert result.data["loginUser"] == nil
      assert Enum.at(result.errors, 0).message == "User not found"
    end

    test "Returns unauthorized when no context is provided" do
      query = """
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
      """

      {:ok, result} = Absinthe.run(
        query,
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

      query = """
      query Users {
        usersQuery {
          messages {
            message
          }
          result {
            name
            username
            email
          }
        }
      }
      """

      {:ok, result} = Absinthe.run(
        query,
        Schema,
        context: absinthe.context
      )

      assert result.data["usersQuery"]["result"] == [
        %{
          "email" => context.user.email,
          "name" => context.user.name,
          "username" => context.user.username
        }
      ]
    end

    test "Can create a user with valid input object", context do
      mutation = """
      mutation CreateUser {
        createUser (user: {
          email: "test2@test.com",
          name: "test name",
          username: "testusername",
          password: "password"
        }) {
          messages {
            message
          }
          result {
            email
            name
            username
          }
          successful
        }
      }
      """

      {:ok, %{data: %{"createUser" => result}}} = Absinthe.run(
        mutation,
        Schema,
        context: %{}
      )

      new_user = Enum.at(Ticketsystem.Accounts.list_users(), -1)

      assert result["result"] == %{
          "email" => new_user.email,
          "name" => new_user.name,
          "username" => new_user.username
        }
      assert Ticketsystem.Accounts.list_users == [context.user, new_user]
    end

    test "Validates uniqueness of username", context do
      mutation = """
      mutation CreateUser {
        createUser (user: {
          email: "test2@test.com",
          name: "test name",
          username: "#{context.user.username}",
          password: "password"
        }) {
          messages {
            field
            message
          }
          result {
            email
            name
            username
          }
          successful
        }
      }
      """

      {:ok, result} = Absinthe.run(
        mutation,
        Schema,
        context: %{}
      )

      assert result.data["createUser"]["messages"] == [%{"field" => "username", "message" => "has already been taken"}]
      assert Ticketsystem.Accounts.list_users == [context.user]
    end

    test "Validates uniqueness of email", context do
      mutation = """
      mutation CreateUser {
        createUser (user: {
          email: "#{context.user.email}",
          name: "test name",
          username: "testusername",
          password: "password"
        }) {
          messages {
            field
            message
          }
          result {
            email
            name
            username
          }
          successful
        }
      }
      """

      {:ok, result} = Absinthe.run(
        mutation,
        Schema,
        context: %{}
      )

      assert result.data["createUser"]["messages"] == [%{"field" => "email", "message" => "has already been taken"}]
      assert Ticketsystem.Accounts.list_users == [context.user]
    end
  end
end
