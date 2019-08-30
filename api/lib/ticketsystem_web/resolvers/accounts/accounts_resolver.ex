defmodule TicketsystemWeb.Resolvers.Accounts do
  @moduledoc """
  Accounts resolver
  """
  alias Ticketsystem.{Accounts, AuthHelper, Guardian}
  alias AbsintheErrorPayload.ValidationMessage

  def list_users(_parent, _args, %{context: %{current_user: _user}}) do
    {:ok, Accounts.list_users()}
  end

  def list_users(_parent, _args, _resolution) do
    {:ok, %ValidationMessage{field: :authorization, code: "denied", message: "not authorized to access this resource"}}
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
    else
      {:error, error} -> {:ok, %ValidationMessage{field: :credentials, code: "invalid", message: "#{error}"}}
    end
  end
end
