defmodule Backend.Repo.Migrations.CreateHealthDatas do
  use Ecto.Migration

  def change do
    create table(:health_datas) do
      add(:date, :date)
      add(:step, :integer)
      add(:comment, :text)
      add(:sleep_begin, :time)
      add(:sleep_end, :time)
      add(:user_id, references(:users, on_delete: :delete_all))

      timestamps()
    end

    create(index(:health_datas, [:user_id]))
  end
end
