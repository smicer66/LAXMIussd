defmodule Ussd.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_users" do
    field :email, :string
    field :fullname, :string
    field :password, :string
    field :phone, :string
    field :status, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :fullname, :email, :phone, :status])
    |> validate_required([:username, :password, :fullname, :email, :phone, :status])
    |> update_change(:password, &Base.encode16(:crypto.hash(:sha512, &1), case: :lower))
  end
end

# ---------------------------------------------------user_creation
# Ussd.Accounts.create_user(%{email: "api@user.com", fullname: "ZICB Api User", password: "api@2021", status: "1", phone: "0762044893", username: "zicb@api", inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})
