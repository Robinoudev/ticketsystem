defmodule Ticketsystem.Companies do
  @moduledoc """
  The Companies context
  """

  import Ecto.Query, warn: false
  alias Ticketsystem.Repo

  alias Ticketsystem.Companies.Company


  @doc """
  Returns list of companies
  """
  def list_companies do
    Repo.all(Company)
  end

  @doc """
  Gets a single company.
  """
  def get_company(id), do: Repo.get(Company, id)

  @doc """
  Gets the company from `attrs.id` if any and updates otherwise inserts new Company
  """
  def insert_or_update_company(attrs \\ {}) do
    company =
      case Map.fetch(attrs, :id) do
        {:ok, _value} -> Repo.get(Company, attrs.id)
        :error -> %Company{}
      end
      |> Company.changeset(attrs)
      |> Repo.insert_or_update

    company
  end
end
