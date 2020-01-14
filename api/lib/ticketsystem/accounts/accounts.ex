defmodule Ticketsystem.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Canada
  import Ecto.Query, warn: false
  alias AbsintheErrorPayload.ValidationMessage
  alias Ticketsystem.Allow
  alias Ticketsystem.Repo
  require Ticketsystem.Allow

  alias Ticketsystem.Accounts.User

  @doc """
  Returns the list of users.
  """
  def list_users(current_user) do
    case Allow.authorize(User, :read, current_user) do
      {:error, %ValidationMessage{} = message} -> {:error, message}
      User -> {:ok, Repo.all(User)}
    end
  end

  @doc """
  Gets a single user.
  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Updates or inserts a user.
  """
  def insert_or_update_user(attrs \\ %{}, current_user) do
    user =
      case Map.fetch(attrs, :id) do
        {:ok, _value} -> Repo.get(User, attrs.id) |> Allow.authorize(:update, current_user)
        :error -> %User{company_id: String.to_integer(attrs.company_id)} |> Allow.authorize(:create, current_user)
      end

    case user do
      {:error, %ValidationMessage{} = message} -> {:error, message}
      _ -> user |> User.changeset(attrs) |> Repo.insert_or_update()
    end
  end
end
