defmodule TicketsystemWeb.Resolvers.TicketsMutationTest do
  use TicketsystemWeb.ConnCase, async: true
  use Plug.Test
  import Ticketsystem.AbsintheHelpers
  alias Ticketsystem.Tickets
  alias Ticketsystem.Repo

  @ticket_mutation """
  mutation CreateTicket ($ticket: TicketMutationParams) {
    ticketMutation (ticket: $ticket) {
      messages {
        field
        message
      }
      result {
        id
        title
        status
        priority
      }
    }
  }
  """

  describe "Tickets resolver mutations" do
    setup do
      %{
        user: insert(:user_with_company)
      }
    end

    test "should create a ticket with valid attrs and context", ctx do
      variables = %{
        "ticket" => %{
          "title" => "valid title",
          "description" => "valid description"
        }
      }

      {:ok, %{data: %{"ticketMutation" => result}}} =
        Absinthe.run(
          @ticket_mutation,
          Schema,
          context: context_for(ctx.user),
          variables: variables
        )

      ticket = List.last(Repo.all(Tickets.Ticket))
      assert result["result"]["title"] == ticket.title
    end

    test "should update ticket when an existing id is given", ctx do
      ticket = insert(:ticket, issuer_id: ctx.user.id)

      variables = %{
        "ticket" => %{
          "id" => ticket.id,
          "title" => "updated title",
          "description" => "updated description"
        }
      }

      {:ok, %{data: %{"ticketMutation" => result}}} =
        Absinthe.run(
          @ticket_mutation,
          Schema,
          context: context_for(ctx.user),
          variables: variables
        )

      tickets = Repo.all(Tickets.Ticket)

      assert length(tickets) == 1
      assert List.last(tickets).title == "updated title"
      assert List.last(tickets).description == "updated description"
      assert result["result"]["title"] == "updated title"
      assert result["result"]["id"] == "#{ticket.id}"
    end

    test "should validate length of description and title", ctx do
      variables = %{
        "ticket" => %{
          "title" => "no",
          "description" => "no"
        }
      }

      {:ok, %{data: %{"ticketMutation" => result}}} =
        Absinthe.run(
          @ticket_mutation,
          Schema,
          context: context_for(ctx.user),
          variables: variables
        )

      assert result["messages"] == [
               %{
                 "field" => "description",
                 "message" => "should be at least 4 character(s)"
               },
               %{"field" => "title", "message" => "should be at least 4 character(s)"}
             ]
    end

    test "should set default values for status and priority", ctx do

    end
  end
end
