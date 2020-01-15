defmodule Ticketsystem.Companies do
  @moduledoc """
  The Companies context
  """

  import Canada
  import Ecto.Query, warn: false
  alias AbsintheErrorPayload.ValidationMessage
  alias Ticketsystem.Allow
  alias Ticketsystem.Repo
  require Ticketsystem.Allow

  alias Ticketsystem.Companies.Company

  @doc """
  Returns list of companies
  """
  def list_companies(current_user) do
    case Allow.authorize(Company, :read, current_user) do
      {:error, %ValidationMessage{} = message} -> {:error, message}
      Company -> {:ok, Repo.all(Company)}
    end
  end

  @doc """
  Gets the company from `attrs.id` if any and updates otherwise inserts new Company
  """
  def insert_or_update_company(attrs \\ %{}, current_user) do
    company =
      case Map.fetch(attrs, :id) do
        {:ok, _value} -> Repo.get(Company, attrs.id) |> Allow.authorize(:update, current_user)
        :error -> %Company{}
      end

    case company do
      {:error, %ValidationMessage{} = message} -> {:error, message}
      _ -> company |> Company.changeset(attrs) |> Repo.insert_or_update()
    end
  end
end
