defmodule Ticketsystem.TicketFactory do
  @moduledoc false
  alias Faker.Lorem.Shakespeare

  defmacro __using__(_opts) do
    quote do
      def ticket_factory do
        %Ticketsystem.Tickets.Ticket{
          title: Shakespeare.hamlet(),
          description: Shakespeare.hamlet()
        }
      end
    end
  end
end
