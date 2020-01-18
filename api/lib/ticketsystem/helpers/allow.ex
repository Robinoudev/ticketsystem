defmodule Ticketsystem.Allow do
  @moduledoc """
  Helper to implement `can?` for Ability checks
  """

  alias AbsintheErrorPayload.ValidationMessage

  defmacro authorize(object, action, user) do
    quote do
      cond do
        unquote(object) && unquote(user) |> can?(unquote(action)(unquote(object))) ->
          unquote(object)

        unquote(object) ->
          {:error,
           %ValidationMessage{
             field: :authorization,
             code: "denied",
             message: "not authorized to access this resource"
           }}

        unquote(user) ->
          {:error, %ValidationMessage{field: :id, code: "id", message: "resource not found"}}

        true ->
          {:error,
           %ValidationMessage{field: :unknown, code: "unknown", message: "unknown server error"}}
      end
    end
  end
end
