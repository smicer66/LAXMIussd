defmodule Ussd.Ussd.Logs do
  use Endon

  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :request, :string
    field :response, :string
    field :source, :string

    timestamps()
  end

  @doc false
  def changeset(logs, attrs) do
    logs
    |> cast(attrs, [:request, :response, :source])
    |> validate_required([:request, :source])
  end
end
