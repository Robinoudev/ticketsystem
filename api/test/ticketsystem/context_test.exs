defmodule Ticketsystem.ContextTest do
  use TicketsystemWeb.ConnCase
  use Plug.Test
  import Ticketsystem.Factory

  describe "Context Plug" do
    test "Validates token in req_header" do
      company = insert(:company)
      user = insert(:user, company: company)

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
    end
  end
end
