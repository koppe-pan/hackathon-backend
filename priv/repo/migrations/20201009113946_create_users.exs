defmodule Backend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:companies) do
      timestamps()
    end

    create table(:users) do
      add(:name, :string)
      add(:point, :integer)
      add(:role, :string)
      add(:company_id, references(:companies, on_delete: :nothing))

      timestamps()
    end
  end
end
