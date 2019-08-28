defmodule TicketsystemWeb.Resolvers.Companies do
  alias Ticketsystem.Companies

  def list_companies(_parent, _args, %{context: %{current_user: _user}}) do
    {:ok, Companies.list_companies()}
  end

  def list_companies(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end

  def mutate_company(_parent, args, %{context: %{current_user: _user}}) do
    result =
      case Companies.insert_or_update_company(args.company) do
        {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
        {:ok, company} -> {:ok, company}
        nil -> {:ok, %AbsintheErrorPayload.ValidationMessage{field: :id, code: "not found", message: "does not exist"}}
      end
    result
  end

  def mutate_company(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end
end
