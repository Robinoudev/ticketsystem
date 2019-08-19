defmodule Ticketsystem.Factory do
  use ExMachina.Ecto, repo: Ticketsystem.Repo
  use Ticketsystem.UserFactory
end
