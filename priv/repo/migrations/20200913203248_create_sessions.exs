defmodule Ussd.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :user_mobile, :string
      add :session_data, :string
      add :options, :string
      add :source, :string

      timestamps()
    end

  end
end
