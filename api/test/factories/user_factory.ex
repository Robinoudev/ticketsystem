defmodule Ticketsystem.UserFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Ticketsystem.Accounts.User{
          email: Faker.Internet.email(),
          inserted_at: ~N[2019-08-15 12:00:41],
          name: Faker.Name.name(),
          password: nil,
          password_hash: "$2b$12$.a7T3QrjTY5SQkQq8VZtYufpO3vLvmhf3M5.L/YlWe1W2sSPFBYh6",
          updated_at: ~N[2019-08-15 12:00:41],
          username: Faker.Name.first_name()
        }
      end
    end
  end
end
