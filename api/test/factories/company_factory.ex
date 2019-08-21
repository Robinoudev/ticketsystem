defmodule Ticketsystem.CompanyFactory do
  defmacro __using__(_opts) do
    quote do
      def company_factory do
        %Ticketsystem.Companies.Company{
          name: Faker.Company.name
        }
      end
    end
  end
end
