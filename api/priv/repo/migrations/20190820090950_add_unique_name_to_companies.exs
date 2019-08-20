defmodule Ticketsystem.Repo.Migrations.AddUniqueNameToCompanies do
  use Ecto.Migration

  def change do
    create unique_index(:companies, :name)
  end
end
