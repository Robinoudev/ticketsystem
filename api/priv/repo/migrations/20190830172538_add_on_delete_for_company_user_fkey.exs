defmodule Ticketsystem.Repo.Migrations.AddOnDeleteForCompanyUserFkey do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :company_id, references(:companies, on_delete: :delete_all)
    end
  end
end
