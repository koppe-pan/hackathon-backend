defmodule BackendWeb.CouponControllerTest do
  use BackendWeb.ConnCase

  alias Backend.Coupons
  alias Backend.Coupons.Coupon

  @create_attrs %{
    cost: 42,
    description: "some description",
    life_time: ~N[2010-04-17 14:00:00]
  }
  @update_attrs %{
    cost: 43,
    description: "some updated description",
    life_time: ~N[2011-05-18 15:01:01]
  }
  @invalid_attrs %{cost: nil, description: nil, life_time: nil}

  def fixture(:coupon) do
    {:ok, coupon} = Coupons.create_coupon(@create_attrs)
    coupon
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all coupons", %{conn: conn} do
      conn = get(conn, Routes.coupon_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create coupon" do
    test "renders coupon when data is valid", %{conn: conn} do
      conn = post(conn, Routes.coupon_path(conn, :create), coupon: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.coupon_path(conn, :show, id))

      assert %{
        "id" => id,
        "cost" => 42,
        "description" => "some description",
        "life_time" => "2010-04-17T14:00:00"
} = json_response(conn, 200)["data"]
  end

test "renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, Routes.coupon_path(conn, :create), coupon: @invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end
end

  describe "update coupon" do
    setup [:create_coupon]

    test "renders coupon when data is valid", %{conn: conn, coupon: %Coupon{id: id} = coupon} do
      conn = put(conn, Routes.coupon_path(conn, :update, coupon), coupon: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.coupon_path(conn, :show, id))

      assert %{
        "id" => id,
        "cost" => 43,
        "description" => "some updated description",
        "life_time" => "2011-05-18T15:01:01"
      } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, coupon: coupon} do
      conn = put(conn, Routes.coupon_path(conn, :update, coupon), coupon: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete coupon" do
    setup [:create_coupon]

    test "deletes chosen coupon", %{conn: conn, coupon: coupon} do
      conn = delete(conn, Routes.coupon_path(conn, :delete, coupon))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
                get(conn, Routes.coupon_path(conn, :show, coupon))
    end
  end
end

defp create_coupon(_) do
  coupon = fixture(:coupon)
    {:ok, coupon: coupon}
  end
end
