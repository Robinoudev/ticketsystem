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

  def insert_or_update_company(attrs \\ {}) do
    %Company{}
      |> Company.changeset(attrs)
      |> Repo.insert_or_update
  end
end
