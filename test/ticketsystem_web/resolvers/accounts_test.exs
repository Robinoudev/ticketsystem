defmodule TicketsystemWeb.Resolvers.AccountsTest do
  use TicketsystemWeb.ConnCase

  use Plug.Test

  describe "Accounts resolver" do
    @user_attrs %{
      email: "email@email.com",
      name: "name",
      password: "password",
      username: "username"
    }

    test "Can create a user" do
      user =
        TicketsystemWeb.Resolvers.Accounts.create_user(%{}, @user_attrs, %{})
        |> elem(1)

      assert user.name == "name"
    end
  end
end