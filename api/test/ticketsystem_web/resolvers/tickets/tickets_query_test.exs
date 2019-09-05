defmodule TicketsystemWeb.Resolvers.TicketsQueryTest do
  use TicketsystemWeb.ConnCase, async: true
  use Plug.Test
  import Ticketsystem.AbsintheHelpers

  @tickets_query """
  query Tickets {
    ticketsQuery {
      messages {
        field
        message
      }
      result {
        title
        description
        issuer {
          name
          username
        }
      }
    }
  }
  """

  describe "Tickets resolver queries" do
    setup do
      %{
        user: insert(:user_with_company)
      }
    end

    test "Returns unauthorized when not logged in" do
      {:ok, %{data: %{"ticketsQuery" => result}}} =
        Absinthe.run(
          @tickets_query,
          Schema
        )

      assert result["messages"] == [
               %{
                 "field" => "authorization",
                 "message" => "not authorized to access this resource"
               }
             ]
    end

    test "Returns list of tickets when valid context is provided", ctx do
      ticket = insert(:ticket, issuer_id: ctx.user.id)

      {:ok, %{data: %{"ticketsQuery" => result}}} =
        Absinthe.run(
          @tickets_query,
          Schema,
          context: context_for(ctx.user)
        )

      assert result["result"] == [
               %{
                 "description" => ticket.description,
                 "issuer" => %{"name" => ctx.user.name, "username" => ctx.user.username},
                 "title" => ticket.title
               }
             ]
    end
  end
end
