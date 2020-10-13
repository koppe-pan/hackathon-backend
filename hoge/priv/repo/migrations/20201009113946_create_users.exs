defmodule Backend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add(:slack_company_id, :string)
      add(:token, :string)
      timestamps()
    end

    create table(:users) do
      add(:slack_user_id, :string)
      add(:name, :string)
      add(:point, :integer)
      add(:role, :string)
      add(:company_id, references(:companies, on_delete: :delete_all))

      timestamps()
    end
  end
end