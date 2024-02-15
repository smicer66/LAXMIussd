defmodule UssdWeb.LogsController do
  use UssdWeb, :controller

  def mno_logs_recieved(conn, _params) do
    render(conn, "mno_received.html")
  end

  def mno_logs_sent(conn, _params) do
    render(conn, "mno_sent.html")
  end
end
