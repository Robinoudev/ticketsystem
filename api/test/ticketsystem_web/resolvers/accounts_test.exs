defmodule TicketsystemWeb.Resolvers.AccountsTest do
  use TicketsystemWeb.ConnCase

  use Plug.Test

  alias TicketsystemWeb.Schema

  describe "Accounts resolver" do
    @user_attrs %{
      email: "email@email.com",
      name: "name",
      password: "password",
      username: "username"
    }

    @unauthorized_context %{}
    @authorized_context %{}

    test "Returns unauthorized when no context is provided" do
      # user =
      #   TicketsystemWeb.Resolvers.Accounts.create_user(%{}, @user_attrs, %{})
      #   |> elem(1)
      #
      # assert user.name == "name"
      query = """
      {
        users {
          id
          name
          username
        }
      }
      """

      {:ok, result} = Absinthe.run(
        query,
        Schema,
        context: @unauthorized_context
      )

      assert result.data['users'] == nil
      assert Enum.at(result.errors, 0).message == "Access denied"
    end

    test "Returns users when a valid context is provided" do
      query = """
      {
        users {
          id
          name
          username
        }
      }
      """

      # TODO: Create valid context en assert list of users

      {:ok, result} = Absinthe.run(
        query,
        Schema,
        context: @authorized_context
      )

      assert result.data['users'] == nil
      assert Enum.at(result.errors, 0).message == "Access denied"
    end

    # test "Can create a user with valid input object" do
    #   mutation = """
    #   mutation CreateUser ($params: CreateUserParams) {
    #     createUser (user: $params) {
    #       messages {
    #         message
    #       }
    #       result {
    #         email
    #       }
    #       successful
    #     }
    #   }
    #   """
    #
    #   {:ok, result} = Absinthe.run(
    #     query,
    #     Schema,
    #     context: @authorized_context
    #   )
    # end
  end
end
