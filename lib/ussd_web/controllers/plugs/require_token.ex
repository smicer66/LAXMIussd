defmodule UssdWeb.Plugs.RequireToken do
  @behaviour Plug
  import Plug.Conn
  import  Ussd.Security.JwtToken

  alias Ussd.Constants, as: Message
  alias UssdWeb.PaymentsController, as: Callback

  def init(default), do: default

  def call(conn, _default) do
    if Plug.Conn.get_req_header(conn, "auth_token") != [] do
      [auth_token] = Plug.Conn.get_req_header(conn, "auth_token")

      auth_token |> verify_token(conn) |> case do
       {:error, _} -> Callback.respond(conn, Message.message_session_expired(), :unauthorized) |> halt()
       {:ok, _claims, call_conn} ->
        call_conn
      end
    else
      Callback.respond(conn, Message.unauthorized(), :unauthorized) |> halt()
    end
  end

end
