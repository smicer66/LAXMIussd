defmodule Ussd.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :full_name, :string
      add :email, :string
      add :phone, :string
      add :id_no, :string
      add :status, :string
      add :login_id, :string
      add :password, :string
      add :created_by, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:users, [:created_by])
  end
end
