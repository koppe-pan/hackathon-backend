defmodule Backend.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :point, :integer, default: 0
    field :role, :string
    has_many :coupons, Backend.Coupons.Coupon
    has_one :health_data, Backend.HealthDatas.HealthData
    belongs_to :company, Backend.Companies.Company

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :role])
    |> validate_required([:name, :role])
  end
end
