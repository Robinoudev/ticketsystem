defmodule TicketsystemWeb.Resolvers.Accounts do
  @moduledoc """
  Accounts resolver
  """
  alias Ticketsystem.{Accounts, AuthHelper, Guardian}

  def list_users(_parent, _args, %{context: %{current_user: _user}}) do
    {:ok, Accounts.list_users()}
  end

  def list_users(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def create_user(_parent, args, _resolution) do
    case Accounts.create_user(args.user) do
      {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
      {:ok, user} -> {:ok, user}
    end
  end

  def login(_parent, %{user: %{email: email, password: password}}, _resolution) do
    with {:ok, user} <- AuthHelper.login_with_email_pass(email, password),
         {:ok, jwt, _} <- Guardian.encode_and_sign(user) do
            user_fields = %{
              token: jwt,
              id: user.id,
              email: user.email,
              username: user.username,
              name: user.name
            }

            {:ok, user_fields}
    end
  end
end
