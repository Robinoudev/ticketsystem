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

  def insert_or_update_company(attrs) do
    company =
      case Ticketsystem.Repo.get_by(Company, name: attrs.name) do
        nil -> %Company{name: attrs.name}
        company -> company
      end
      |> Company.changeset(attrs)
      |> Ticketsystem.Repo.insert_or_update
  end
end
