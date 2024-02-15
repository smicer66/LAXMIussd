defmodule Ussd.Ussd.Logs_archive do
  use Endon

  use Ecto.Schema
  import Ecto.Changeset

  schema "logs_archive" do
    field :request, :string
    field :response, :string
    field :source, :string

    timestamps()
  end

  @doc false
  def changeset(logs_archive, attrs) do
    logs_archive
    |> cast(attrs, [:request, :response, :source])
    |> validate_required([:request, :response, :source])
  end
end
