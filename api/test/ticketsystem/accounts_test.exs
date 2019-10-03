defmodule Ticketsystem.AccountsTest do
  use Ticketsystem.DataCase
  import Ticketsystem.Factory

  alias Ticketsystem.Accounts
  alias Ticketsystem.Accounts.User

  describe "users" do

    setup do
      %{
        company: insert(:company),
        current_user: insert(:user_with_company, roles: ["superadmin"])
      }
    end

    test "list_users/0 returns all users", context do
      insert_list(3, :user, company: context.company)
      users = Accounts.list_users()
      assert length(users) == 4
    end

    test "get_user!/1 returns the user with given id", context do
      user = insert(:user, company: context.company)
      database_user = Accounts.get_user!(user.id)
      assert database_user.name == user.name
      assert database_user.username == user.username
      assert database_user.email == user.email
    end

    test "when user is superadmin insert_or_update_user/2 with valid data creates a user", context do
      attrs = %{
        email: "valid@email.com",
        password: "password",
        name: "name",
        username: "valid_username",
        company_id: "#{context.company.id}",
        roles: [:admin]
      }

      assert {:ok, %User{} = user} = Accounts.insert_or_update_user(attrs, context.current_user)
      assert user.email == "valid@email.com"
      assert user.name == "name"
      assert user.username == "valid_username"
      assert user.company_id == context.company.id
    end

    test "insert_or_update_user/2 with invalid data returns error changeset", ctx do
      attrs = %{
        email: nil,
        password: nil,
        name: nil,
        username: nil,
        company_id: "999"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.insert_or_update_user(attrs, ctx.current_user)
      assert changeset.errors == [
        name: {"can't be blank", [validation: :required]},
        username: {"can't be blank", [validation: :required]},
        email: {"can't be blank", [validation: :required]},
        password: {"can't be blank", [validation: :required]}
      ]
    end

    test "when user is an admin it can add users to its own company", ctx do
      admin_user = insert(:user, company: ctx.company, roles: ["admin"])

      new_attrs = %{
        email: "valid@email.com",
        password: "password",
        name: "name",
        username: "valid_username",
        company_id: "#{admin_user.company.id}"
      }

      users_before = Repo.all(User)

      assert {:ok, %User{} = user} = Accounts.insert_or_update_user(new_attrs, admin_user)
      assert user.email == "valid@email.com"
      assert user.name == "name"
      assert user.username == "valid_username"
      assert user.company_id == admin_user.company.id
      assert length(Repo.all(User)) == length(users_before) + 1
    end

    test "when user is an admin it can update users of its own company", ctx do
      admin_user = insert(:user, company: ctx.company, roles: ["admin"])
      second_user = insert(:user, company: admin_user.company)

      updated_attrs = %{
        id: "#{second_user.id}",
        email: "updated@email.com",
        password: "password",
        name: "updated",
        username: "updated",
        company_id: "#{admin_user.company.id}"
      }

      users_before = Repo.all(User)

      assert {:ok, %User{} = user} = Accounts.insert_or_update_user(updated_attrs, admin_user)
      assert user.email == "updated@email.com"
      assert user.name == "updated"
      assert user.username == "updated"
      assert user.company_id == admin_user.company.id
      assert length(Repo.all(User)) == length(users_before)
    end

    test "when user is an admin it cannot add or update users of another company" do
      admin_user = insert(:user_with_company, roles: ["admin"])

      attrs = %{
        email: "valid@email.com",
        password: "password",
        name: "name",
        username: "valid_username",
        company_id: "3"
      }

      {:error, %AbsintheErrorPayload.ValidationMessage{} = message}= Accounts.insert_or_update_user(attrs, admin_user)

      assert message == %AbsintheErrorPayload.ValidationMessage{
        code: "denied",
        field: :authorization,
        key: nil,
        message: "not authorized to access this resource",
        options: [],
        template: "is invalid"
      }
    end

    test "when user is a handler or regular user it cannot insert or update users", ctx do
      user = insert(:user, company: ctx.company, roles: ["issuer"])

      attrs = %{
        email: "valid@email.com",
        password: "password",
        name: "name",
        username: "valid_username",
        company_id: "#{ctx.company.id}"
      }

      {:error, %AbsintheErrorPayload.ValidationMessage{} = message}= Accounts.insert_or_update_user(attrs, user)
      assert message == %AbsintheErrorPayload.ValidationMessage{
        code: "denied",
        field: :authorization,
        key: nil,
        message: "not authorized to access this resource",
        options: [],
        template: "is invalid"
      }
    end
  end
end
