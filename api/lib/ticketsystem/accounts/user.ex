defmodule Ticketsystem.Accounts.User do
  @moduledoc """
  User model
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Ticketsystem.Companies.Company
  alias Ticketsystem.Tickets.Ticket

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :username, :string
    field :password, :string, virtual: true
    field :roles, {:array, RoleEnum}

    has_many :issued_tickets, Ticket, foreign_key: :issuer_id
    has_many :handled_tickets, Ticket, foreign_key: :handler_id
    belongs_to :company, Company

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :email, :password, :company_id, :roles])
    |> validate_required([:name, :username, :email, :password, :company_id])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:username, name: :users_username_index)
    |> unique_constraint(:email, name: :users_email_index)
    |> foreign_key_constraint(:company_id, name: :users_company_id_fkey)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset) do
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(pass))
  end

  defp put_password_hash(changeset), do: changeset
end
