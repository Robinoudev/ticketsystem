defmodule Ticketsystem.AuthHelperTest do
  use Ticketsystem.DataCase
  import Ticketsystem.Factory

  alias Ticketsystem.AuthHelper

  describe "auth_helper" do
    alias Ticketsystem.Accounts

    setup do
      %{company: insert(:company)}
    end

    test "login_with_email_pass/2 returns user when credentials match", context do
      user = insert(:user, company: context.company)

      logged_in_user =
        AuthHelper.login_with_email_pass(user.email, "password")
        |> elem(1)

      assert user.id == logged_in_user.id
    end

    test "login_with_email_pass/2 returns Invalid credentials when password is wrong", context do
      user = insert(:user, company: context.company)

      assert AuthHelper.login_with_email_pass(user.email, "wrongpassword") ==
               {:error, "Invalid credentials"}
    end

    test "login_with_email_pass/2 returns User not found when email is wrong" do

      assert AuthHelper.login_with_email_pass("invalid@email.com", "password") ==
               {:error, "User not found"}
    end
  end
end
