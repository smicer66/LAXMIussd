defmodule Ussd.Repo.Migrations.CreateConfigs do
  use Ecto.Migration

  def change do
    create table(:configs) do
      add :name, :string
      add :value, :string

      timestamps()
    end

  end
end
