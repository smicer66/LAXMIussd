defmodule Ussd.Ussd.Configs do
  use Endon

  use Ecto.Schema
  import Ecto.Changeset

  schema "configs" do
    field :name, :string
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(configs, attrs) do
    configs
    |> cast(attrs, [:name, :value])
    |> validate_required([:value])
  end
end
