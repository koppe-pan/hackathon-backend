defmodule Backend.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add(:slack_company_id, :string)
      add(:token, :string)
      add(:coupon_id, references(:coupons, on_delete: :nilify_all))
      timestamps()
    end
  end
end
