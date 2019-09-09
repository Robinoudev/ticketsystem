defimpl Canada.Can, for: Ticketsystem.Accounts.User do
  def can?(%Ticketsystem.Accounts.User{ id: user_id }, action, %Ticketsystem.Tickets.Ticket{ issuer_id: user_id })
    when action in [:read, :update, :touch], do: true

  def can?(%Ticketsystem.Accounts.User{ id: user_id }, _, _), do: false
end
