defmodule Ussd.Ussd.Users do
  use Endon

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :full_name, :string
    # field :id_no, :string
    field :login_id, :string
    field :password, :string
    field :phone, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:full_name, :email, :phone, :status, :password, :login_id])
    |> validate_required([:email, :password])
  end

end
