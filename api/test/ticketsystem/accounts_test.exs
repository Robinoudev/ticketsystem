defmodule Ticketsystem.AccountsTest do
  use Ticketsystem.DataCase
  import Ticketsystem.Factory

  alias Ticketsystem.Accounts

  describe "users" do
    alias Ticketsystem.Accounts.User

    setup do
      %{company: insert(:company)}
    end

    test "list_users/0 returns all users", context do
      insert_list(3, :user, company: context.company)
      users = Accounts.list_users()
      assert length(users) == 3
    end

    test "get_user!/1 returns the user with given id", context do
      user = insert(:user, company: context.company)
      database_user = Accounts.get_user!(user.id)
      assert database_user.name == user.name
      assert database_user.username == user.username
      assert database_user.email == user.email
    end

    test "create_user/1 with valid data creates a user", context do
      attrs = %{
        "email" => "valid@email.com",
        "password" => "password",
        "name" => "name",
        "username" => "valid_username",
        "company_id" => context.company.id
      }
      assert {:ok, %User{} = user} = Accounts.create_user(attrs)
      assert user.email == "valid@email.com"
      assert user.name == "name"
      assert user.username == "valid_username"
      assert user.company_id == context.company.id
    end

    test "create_user/1 with invalid data returns error changeset" do
      attrs = %{
        "email" => nil,
        "password" => nil,
        "name" => nil,
        "username" => nil,
        "company_id" => nil
      }
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(attrs)
    end
  end
end
