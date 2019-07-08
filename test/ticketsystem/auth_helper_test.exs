defmodule Ticketsystem.AuthHelperTest do
  use Ticketsystem.DataCase

  alias Ticketsystem.AuthHelper

  describe "auth_helper" do
    alias Ticketsystem.Accounts
    alias Ticketsystem.Accounts.User

    @user_attrs %{
      email: "email@email.com",
      name: "name",
      password: "password",
      username: "username"
    }
    @valid_login %{email: "email@email.com", password: "password"}
    @invalid_login %{email: "wrong@email.com", password: "wrongpassword"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@user_attrs)
        |> Accounts.create_user()

      user
    end

    test "login_with_email_pass/2 returns user when credentials match" do
      user = user_fixture()

      logged_in_user =
        AuthHelper.login_with_email_pass(@valid_login.email, @valid_login.password)
        |> elem(1)

      assert user.id == logged_in_user.id
    end

    test "login_with_email_pass/2 returns Invalid credentials when password is wrong" do
      user_fixture()

      assert AuthHelper.login_with_email_pass(@valid_login.email, @invalid_login.password) ==
               {:error, "Invalid credentials"}
    end

    test "login_with_email_pass/2 returns User not found when email is wrong" do
      user_fixture()

      assert AuthHelper.login_with_email_pass(@invalid_login.email, @valid_login.password) ==
               {:error, "User not found"}
    end
  end
end
