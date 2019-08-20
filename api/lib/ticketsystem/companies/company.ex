defmodule Ticketsystem.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ticketsystem.Accounts.User

  schema "companies" do
    field :name, :string
    has_many :users, User

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name])
    |> validate_required(:name)
    |> validate_length(:name, min: 2)
    |> unique_constraint(:name, name: :companies_name_index)
  end
end
