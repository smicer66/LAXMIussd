defmodule UssdWeb.HomeController do
  use UssdWeb, :controller

  def home_page(conn, _params) do
    render(conn, "index.html")
  end

end
