defmodule Ticketsystem.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Ticketsystem.Repo
  use Ticketsystem.UserFactory
  use Ticketsystem.CompanyFactory
  use Ticketsystem.TicketFactory
end
