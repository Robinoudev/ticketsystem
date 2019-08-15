defmodule Ticketsystem.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Ticketsystem.Accounts.User{
          email: "email@email.com",
          id: 1,
          inserted_at: ~N[2019-08-15 12:00:41],
          name: "name",
          password: nil,
          password_hash: "$2b$12$.a7T3QrjTY5SQkQq8VZtYufpO3vLvmhf3M5.L/YlWe1W2sSPFBYh6",
          updated_at: ~N[2019-08-15 12:00:41],
          username: "username"
        }
      end
    end
  end
end
