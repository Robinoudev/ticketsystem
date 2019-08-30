defmodule Ticketsystem.Context do
  @moduledoc """
  Context Plug to build and validate authorization context
  """
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case build_context(conn) do
      {:ok, context} ->
        put_private(conn, :absinthe, %{context: context})

      _ ->
        conn
    end
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
      {:ok, %{current_user: current_user, token: token}}
    end
  end

  defp authorize(token) do
    Ticketsystem.Guardian.decode_and_verify(token)
    |> case do
      nil ->
        {:error, "Invalid authorization token provided"}

      sub ->
        sub
        |> elem(1)
        |> case do
          nil -> {:error, "Invalid token"}
          claim -> Ticketsystem.Guardian.resource_from_claims(claim)
        end
    end
  end
end
