defmodule BackendWeb.CouponView do
  use BackendWeb, :view
  alias BackendWeb.CouponView

  def render("index.json", %{coupons: coupons}) do
    render_many(coupons, CouponView, "coupon.json")
  end

  def render("show.json", %{coupon: coupon}) do
    render_one(coupon, CouponView, "coupon.json")
  end

  def render("coupon.json", %{coupon: coupon}) do
    %{
      id: coupon.id,
      cost: coupon.cost,
      description: coupon.description,
      created_at: coupon.inserted_at,
      life_time: coupon.life_time
    }
  end
end
