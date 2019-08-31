defmodule Ticketsystem.Repo.Migrations.RemoveForeignKeyOnUserCompany do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :company_id
    end
  end
end
