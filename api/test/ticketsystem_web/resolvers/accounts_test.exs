defmodule TicketsystemWeb.Resolvers.AccountsTest do
  use TicketsystemWeb.ConnCase
  use Plug.Test
  import Ticketsystem.Factory
  alias TicketsystemWeb.Schema

  describe "Accounts resolver" do
    @unauthorized_context %{}

    test "Can login a user" do
      user = insert(:user)

      mutation = """
      mutation Login {
        loginUser (user: {
          email: "email@email.com",
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

      # require IEx; IEx.pry

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

    test "Returns users when a valid context is provided" do
      user = insert(:user)
      req_headers =
        TicketsystemWeb.Resolvers.Accounts.login(
          %{},
          %{user: %{email: user.email, password: "password"}},
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
          "email" => user.email,
          "name" => user.name,
          "username" => user.username
        }
      ]
    end

    test "Can create a user with valid input object" do
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

      user = Enum.at(Ticketsystem.Accounts.list_users(), 0)

      assert result["result"] == %{
          "email" => user.email,
          "name" => user.name,
          "username" => user.username
        }
      assert Ticketsystem.Accounts.list_users == [user]
    end

    test "Validates uniqueness of username" do
      user = insert(:user)

      mutation = """
      mutation CreateUser {
        createUser (user: {
          email: "test2@test.com",
          name: "test name",
          username: "#{user.username}",
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
      assert Ticketsystem.Accounts.list_users == [user]
    end

    test "Validates uniqueness of email" do
      user = insert(:user)

      mutation = """
      mutation CreateUser {
        createUser (user: {
          email: "#{user.email}",
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
      assert Ticketsystem.Accounts.list_users == [user]
    end
  end
end
