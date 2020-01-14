defmodule TicketsystemWeb.Resolvers.Accounts do
  @moduledoc """
  Accounts resolver
  """
  alias AbsintheErrorPayload.ValidationMessage
  alias Ticketsystem.{Accounts, AuthHelper, Guardian}

  def list_users(_parent, _args, %{context: %{current_user: user}}) do
    case Accounts.list_users(user) do
        {:error, %ValidationMessage{} = message} -> {:ok, message}
        {:ok, users} -> {:ok, users}
    end
  end

  def list_users(_parent, _args, _resolution) do
    {:ok,
     %ValidationMessage{
       field: :authorization,
       code: "denied",
       message: "not authorized to access this resource"
     }}
  end

  def insert_or_update_user(_parent, args, %{context: %{current_user: current_user}}) do
      case Accounts.insert_or_update_user(args.user, current_user) do
        {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
        {:error, %ValidationMessage{} = message} -> {:ok, message}
        {:ok, user} -> {:ok, user}
      end
  end

  def insert_or_update_user(_parent, _args, _resolution) do
    {:ok,
     %ValidationMessage{
       field: :authorization,
       code: "denied",
       message: "not authorized to access this resource"
     }}
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
      {:error, error} ->
        {:ok, %ValidationMessage{field: :credentials, code: "invalid", message: "#{error}"}}
    end
  end
end
