defmodule TicketsystemWeb.Resolvers.Companies do
  def list_companies(_parent, _args, %{context: %{current_user: _user}}) do
    {:ok, Ticketsystem.Companies.list_companies()}
  end

  alias Ticketsystem.Companies.Company

  def list_companies(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def mutate_company(_parent, args, %{context: %{current_user: _user}}) do
    case Ticketsystem.Companies.insert_or_update_company(args.company) do
      {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
      {:ok, company} -> {:ok, company}
    end
  end

  def mutate_company(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end
end
