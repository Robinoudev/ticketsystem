defmodule Ticketsystem.Repo.Migrations.ModifyUserAttributesWithNotNull do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :name, :string, null: false
      modify :username, :string, null: false
      modify :email, :string, null: false
      modify :password_hash, :string, null: false
    end

    alter table(:companies) do
      modify :name, :string, null: false
    end

    create unique_index(:users, :username)
  end
end
