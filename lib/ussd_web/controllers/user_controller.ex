defmodule UssdWeb.UserController do
  use UssdWeb, :controller

  alias Ussd.Ussd.Users
  alias Ussd.Accounts

  def user_management(conn, _params) do
    user = Users.all()
    render(conn, "index.html", users: user)
  end

  def user_create(conn, params) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Account added successfully")
        |> redirect(to: Routes.user_path(conn, :user_management))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end
end
