defmodule Ticketsystem.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Canada
  import Ecto.Query, warn: false
  alias Ticketsystem.Repo
  alias AbsintheErrorPayload.ValidationMessage

  alias Ticketsystem.Accounts.User

  @doc """
  Returns the list of users.
  """
  def list_users do
    Repo.all(User)
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
        {:ok, _value} -> Repo.get(User, attrs.id) |> allow?(current_user)
        :error -> %User{}
      end

    case user do
      {:error, %ValidationMessage{} = message} -> {:error, message}
      _ -> user |> User.changeset(attrs) |> Repo.insert_or_update()
    end
  end

  defp allow?(user, current_user) do
    cond do
      user && current_user |> can?(update(user)) ->
        user
      user ->
        {:error, %ValidationMessage{field: :authorization, code: "denied", message: "not authorized to access this resource"}}
      current_user ->
        {:error, %ValidationMessage{field: :id, code: "id", message: "resource not found"}}
      true ->
        {:error, %ValidationMessage{field: :unknown, code: "unknown", message: "unknown server error"}}
    end
  end
end
