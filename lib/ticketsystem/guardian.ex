defmodule Ticketsystem.Guardian do
  use Guardian, otp_app: :ticketsystem
  alias Ticketsystem.Accounts

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
  {:ok, sub}
 end

  def resource_from_claims(claims) do
    user = claims["sub"] |> Accounts.get_user!
    {:ok,  user}
  end
end
