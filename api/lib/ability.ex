defimpl Canada.Can, for: Ticketsystem.Accounts.User do
  alias Ticketsystem.Accounts.User
  alias Ticketsystem.Tickets.Ticket

  @doc """
  Ability checks for actions on a user struct
  """
  def can?(user, action, object = User) when action in [:create, :update, :destroy] do
    cond do
      :superadmin in user.roles ->
        true

      :admin in user.roles ->
        true

      true ->
        false
    end
  end

  def can?(user, action, object = %User{}) when action in [:create, :update, :destroy] do
    cond do
      :superadmin in user.roles ->
        true

      :admin in user.roles && object.company_id == user.company_id ->
        true

      true ->
        false
    end
  end

  def can?(user, action, object = %User{}) when action in [:read] do
    cond do
      :superadmin in user.roles ->
        true

      object.company_id == user.company_id ->
        true

      true ->
        false
    end
  end

  @doc """
  Ability checks for actions on a Ticket struct
  """

  # Inform of unimplemented ability check
  def can?(subject, action, resource) do
    raise """
    Unimplemented authorization check for User!  To fix see below...

    Please implement `can?` for User in #{__ENV__.file}.

    The function should match:

    subject:  #{inspect(subject)}

    action:   #{action}

    resource: #{inspect(resource)}
    """
  end
end
