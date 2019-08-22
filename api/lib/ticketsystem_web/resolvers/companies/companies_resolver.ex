defmodule TicketsystemWeb.Resolvers.Companies do

  alias Ticketsystem.Companies

  def list_companies(_parent, _args, %{context: %{current_user: _user}}) do
    {:ok, Companies.list_companies()}
  end

  def list_companies(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def get_company_of_user(_parent, _args, %{context: %{current_user: user}}) do
    {:ok, Companies.get_company(user.company_id)}
  end

  def mutate_company(_parent, args, %{context: %{current_user: _user}}) do
    case Companies.insert_or_update_company(args.company) do
      {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
      {:ok, company} -> {:ok, company}
    end
  end

  def mutate_company(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end
end
