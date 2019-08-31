defmodule Ticketsystem.Repo.Migrations.RemoveIndexUserUsername do
  use Ecto.Migration

  def up do
    drop index(:users, [:username])
  end
end
