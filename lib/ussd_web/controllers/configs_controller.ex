defmodule UssdWeb.ConfigsController do
  use UssdWeb, :controller

  def configs(conn, _params) do
    render(conn, "index.html")
  end
end
