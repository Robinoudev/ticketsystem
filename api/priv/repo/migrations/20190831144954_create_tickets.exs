defmodule Ticketsystem.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :title, :string, null: false
      add :description, :string, null: false
      add :status, :string, null: false, default: "draft"
      add :priority, :string, null: false, default: "low"
      add :handled_at, :naive_datetime
      add :issuer_id, references(:users, on_delete: :nilify_all), null: false
      add :handler_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end
  end
end
