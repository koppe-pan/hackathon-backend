defmodule Backend.Repo.Migrations.CreateCoupons do
  use Ecto.Migration

  def change do
    create table(:coupons) do
      add(:cost, :integer)
      add(:description, :text)
      add(:life_time, :naive_datetime)

      timestamps()
    end
  end
end
