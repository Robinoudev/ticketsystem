defmodule TicketsystemWeb.Resolvers.Accounts do
  def list_users(_parent, _args, _resolution) do
    {:ok, Ticketsystem.Accounts.list_users()}
  end

  def create_user(_parent, args, _resolution) do
    Ticketsystem.Accounts.create_user(args)
  end

  def login(_parent, %{email: email, password: password}, _resolution) do
    with {:ok, user} <- Ticketsystem.AuthHelper.login_with_email_pass(email, password),
         {:ok, jwt, _} <- Ticketsystem.Guardian.encode_and_sign(user) do
           {:ok, %{token: jwt, user: user}}
         end
  end
end