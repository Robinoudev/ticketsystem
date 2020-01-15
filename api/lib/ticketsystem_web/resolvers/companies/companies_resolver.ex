defmodule TicketsystemWeb.Resolvers.Companies do
  @moduledoc """
  Companies resolver
  """
  alias AbsintheErrorPayload.ValidationMessage
  alias Ticketsystem.Companies

  def list_companies(_parent, _args, %{context: %{current_user: user}}) do
    case Companies.list_companies(user) do
      {:error, %ValidationMessage{} = message} -> {:ok, message}
      {:ok, companies} -> {:ok, companies}
    end
  end

  def list_companies(_parent, _args, _resolution) do
    {:ok,
     %ValidationMessage{
       field: :authorization,
       code: "denied",
       message: "not authorized to access this resource"
     }}
  end

  def mutate_company(_parent, args, %{context: %{current_user: current_user}}) do
    result =
      case Companies.insert_or_update_company(args.company, current_user) do
        {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
        {:ok, company} -> {:ok, company}
        nil -> {:ok, %ValidationMessage{field: :id, code: "not found", message: "does not exist"}}
      end

    result
  end

  def mutate_company(_parent, _args, _resolution) do
    {:error, "Access denied"}

    {:ok,
     %ValidationMessage{
       field: :authorization,
       code: "denied",
       message: "not authorized to access this resource"
     }}
  end
end
