defmodule TicketsystemWeb.Dataloader.DataTest do
  use TicketsystemWeb.ConnCase, async: true
  use Plug.Test

  describe "Dataloader" do
    test "can convert params into conditional queries" do
      query = TicketsystemWeb.Data.query("usersQuery", %{order_by: :id})
      assert List.first(query.order_bys).expr == [asc: {{:., [], [{:&, [], [0]}, :id]}, [], []}]
    end

    test "it returns the query when no param is found" do
      query = TicketsystemWeb.Data.query("usersQuery", %{})
      assert query == "usersQuery"
    end
  end
end
