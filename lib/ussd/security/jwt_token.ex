defmodule Ussd.Security.JwtToken do
  alias Ussd.Token
  use Joken.Hooks

  @impl true
  def before_generate(_hook_options, {token_config, extra_claims}) do
    {:cont, {token_config, Map.put(extra_claims, "exp", Timex.now |> Timex.shift(hours: 8, minutes: 0) |> Timex.to_unix)}}
  end

  def token(user) do
    extra_claims = %{"user_id" => user.id, "username" => user.username}
    Token.generate_and_sign!(extra_claims)
  end

  def token do
    extra_claims = %{"user_id" => 1, "username" => "PEPV2_2021"}
    Token.generate_and_sign!(extra_claims)
  end

  def verify_token(auth_token, conn) do
    Token.verify_and_validate(auth_token)
    |> case do
         {:ok, claims} ->
          args = %{:user => %{:id => claims["user_id"], :username => claims["username"]}}
          conn = Map.update(conn, :assigns, args, &Map.merge(&1, args))
           {:ok, claims, conn}
          {:error, _} -> {:error, %{}}
     end
  end

  def verify_token(token) do
    Token.verify_and_validate(token)
    |> case do
         {:ok, claims} ->
          args = %{:user => %{:id => claims["user_id"], :username => claims["username"]}}
          # conn = Map.update(conn, :assigns, args, &Map.merge(&1, args))
          #  {:ok, claims, conn}
          IO.inspect args,label: "success"
          {:error, _} -> {:error, %{}}
     end
  end
end
