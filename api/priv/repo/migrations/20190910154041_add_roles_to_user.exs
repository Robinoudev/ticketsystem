defmodule Ticketsystem.Repo.Migrations.AddRolesToUser do
  use Ecto.Migration

  def change do
    alter table("users") do
      add(:roles, {:array, :integer}, default: [3])
    end
  end
end
