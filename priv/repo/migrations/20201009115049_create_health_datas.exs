defmodule Backend.Repo.Migrations.CreateHealthDatas do
  use Ecto.Migration

  def change do
    create table(:health_datas) do
      add(:date, :date)
      add(:step, :integer)
      add(:comment, :text)
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:health_datas, [:user_id]))
  end
end
