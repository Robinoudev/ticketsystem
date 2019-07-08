defmodule Ticketsystem.ContextTest do
  use TicketsystemWeb.ConnCase

  use Plug.Test

  describe "Context Plug" do
    # alias TicketsystemWeb.Resolvers.Accounts

    @user_attrs %{
      email: "email@email.com",
      name: "name",
      password: "password",
      username: "username"
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@user_attrs)
        |> Ticketsystem.Accounts.create_user()

      user
    end

    test "Validates token in req_header" do
      user = user_fixture()

      token =
        TicketsystemWeb.Resolvers.Accounts.login(
          %{},
          %{email: user.email, password: user.password},
          %{}
        )
        |> elem(1)

      conn =
        build_conn()
        |> put_req_header("authorization", "Bearer #{token.token}")
        |> Ticketsystem.Context.call({})

      assert conn.request_path == "/"
      absinthe = conn.private[:absinthe]

      assert absinthe.context.current_user.id == user.id
    end

    test "Wrong credentials give unauthorized error" do
      conn =
        build_conn()
        |> Ticketsystem.Context.init()
        |> Ticketsystem.Context.call({})

      assert conn.private[:absinthe] == nil
      # require IEx; IEx.pry()
    end
  end
end
