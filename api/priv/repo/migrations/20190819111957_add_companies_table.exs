defmodule Ticketsystem.Repo.Migrations.AddCompaniesTable do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string

      timestamps()
    end

    alter table(:users) do
      add :company_id, references(:companies)
    end
  end
end
