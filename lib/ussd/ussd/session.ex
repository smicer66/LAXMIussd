defmodule Ussd.Ussd.Session do
  use Endon

  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :options, :string
    field :session_data, :string
    field :source, :string
    field :user_mobile, :string

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:user_mobile, :session_data, :options, :source])
    |> validate_required([:user_mobile, :session_data, :source])
  end
end
