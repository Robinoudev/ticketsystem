defmodule Ticketsystem.TicketFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def ticket_factory do
        %Ticketsystem.Tickets.Ticket{
          title: Faker.Lorem.Shakespeare.hamlet(),
          description: Faker.Lorem.Shakespeare.hamlet()
        }
      end
    end
  end
end
