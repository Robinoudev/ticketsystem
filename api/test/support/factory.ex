defmodule Ticketsystem.Factory do
  use ExMachina.Ecto, repo: Ticketsystem.Repo
  use Ticketsystem.UserFactory
  use Ticketsystem.CompanyFactory
end
