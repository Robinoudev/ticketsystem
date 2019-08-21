defmodule Ticketsystem.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ticketsystem.Companies.Company

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :username, :string
    field :password, :string, virtual: true
    belongs_to :company, Company

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :email, :password, :company_id])
    |> validate_required([:name, :username, :email, :password, :company_id])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:username, name: :users_username_index)
    |> unique_constraint(:email, name: :users_email_index)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset) do
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(pass))
  end

  defp put_password_hash(changeset), do: changeset
end
