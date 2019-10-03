defimpl Canada.Can, for: Ticketsystem.Accounts.User do
  alias Ticketsystem.Accounts.User
  alias Ticketsystem.Companies.Company
  alias Ticketsystem.Tickets.Ticket

  @doc """
  Ability checks for actions on a `%User{}`
  """
  def can?(user, action, User) when action in [:create, :update, :destroy] do
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
  Ability checks for actions on a `%Ticket{}`
  """
  def can?(user, action, Ticket) when action in [:create, :update, :destroy] do
    if :superadmin in user.roles || :issuer in user.roles, do: true, else: false
  end

  def can?(user, action, object = %Ticket{}) when action in [:create, :update, :destroy] do
    cond do
      :superadmin in user.roles ->
        true

      :issuer in user.roles && user.id == object.issuer_id ->
        true

      true ->
        false
    end
  end

  @doc """
  Ability checks for actions on a `%Company{}`
  """
  def can?(user, action, Company) when action in [:create, :update, :destroy] do
    if :superadmin in user.roles, do: true, else: false
  end

  def can?(user, action, %Company{}) when action in [:create, :update, :destroy] do
    if :superadmin in user.roles, do: true, else: false
  end

  def can?(user, action, object = %Company{}) when action in [:update] do
    cond do
      :superadmin in user.roles ->
        true

      :admin in user.roles && user.company_id == object.id ->
        true

      true ->
        false
    end
  end

  def can?(user, action, object = %Company{}) when action in [:read] do
    cond do
      :superadmin in user.roles ->
        true

      user.company_id == object.id &&
          (:admin in user.roles || :isser in user.roles || :handler in user.roles) ->
        true

      true ->
        false
    end
  end

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
