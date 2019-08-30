defmodule Ticketsystem.AuthHelper do
  @moduledoc false

  alias Ticketsystem.Repo
  alias Ticketsystem.Accounts.User

  def login_with_email_pass(email, given_pass) do
    user = Repo.get_by(User, email: String.downcase(email))

    cond do
      user && Bcrypt.verify_pass(given_pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, "invalid password provided"}

      true ->
        {:error, "no user with given email"}
    end
  end
end
