defmodule Backend.Coupons.Coupon do
  use Ecto.Schema
  import Ecto.Changeset

  schema "coupons" do
    field(:cost, :integer)
    field(:description, :string)
    field(:life_time, :naive_datetime)
    timestamps()
  end

  @doc false
  def changeset(coupon, attrs) do
    coupon
    |> cast(attrs, [:cost, :description, :life_time])
    |> validate_required([:cost, :description, :life_time])
  end
end
