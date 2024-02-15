defmodule Ussd.Repo.Migrations.CreateLogsArchive do
  use Ecto.Migration

  def change do
    create table(:logs_archive) do
      add :request, :string
      add :response, :string
      add :source, :string

      timestamps()
    end

  end
end
