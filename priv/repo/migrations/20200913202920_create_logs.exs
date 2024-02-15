defmodule Ussd.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :request, :string
      add :response, :string
      add :source, :string

      timestamps()
    end

  end
end
