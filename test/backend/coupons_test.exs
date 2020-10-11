defmodule Backend.CouponsTest do
  use Backend.DataCase

  alias Backend.Coupons

  describe "coupons" do
    alias Backend.Coupons.Coupon

    @valid_attrs %{cost: 42, description: "some description", life_time: ~N[2010-04-17 14:00:00]}
    @update_attrs %{cost: 43, description: "some updated description", life_time: ~N[2011-05-18 15:01:01]}
    @invalid_attrs %{cost: nil, description: nil, life_time: nil}

    def coupon_fixture(attrs \\ %{}) do
      {:ok, coupon} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Coupons.create_coupon()

      coupon
    end

    test "list_coupons/0 returns all coupons" do
      coupon = coupon_fixture()
      assert Coupons.list_coupons() == [coupon]
    end

    test "get_coupon!/1 returns the coupon with given id" do
      coupon = coupon_fixture()
      assert Coupons.get_coupon!(coupon.id) == coupon
    end

    test "create_coupon/1 with valid data creates a coupon" do
      assert {:ok, %Coupon{} = coupon} = Coupons.create_coupon(@valid_attrs)
      assert coupon.cost == 42
      assert coupon.description == "some description"
      assert coupon.life_time == ~N[2010-04-17 14:00:00]
    end

    test "create_coupon/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Coupons.create_coupon(@invalid_attrs)
    end

    test "update_coupon/2 with valid data updates the coupon" do
      coupon = coupon_fixture()
      assert {:ok, %Coupon{} = coupon} = Coupons.update_coupon(coupon, @update_attrs)
      assert coupon.cost == 43
      assert coupon.description == "some updated description"
      assert coupon.life_time == ~N[2011-05-18 15:01:01]
    end

    test "update_coupon/2 with invalid data returns error changeset" do
      coupon = coupon_fixture()
      assert {:error, %Ecto.Changeset{}} = Coupons.update_coupon(coupon, @invalid_attrs)
      assert coupon == Coupons.get_coupon!(coupon.id)
    end

    test "delete_coupon/1 deletes the coupon" do
      coupon = coupon_fixture()
      assert {:ok, %Coupon{}} = Coupons.delete_coupon(coupon)
      assert_raise Ecto.NoResultsError, fn -> Coupons.get_coupon!(coupon.id) end
    end

    test "change_coupon/1 returns a coupon changeset" do
      coupon = coupon_fixture()
      assert %Ecto.Changeset{} = Coupons.change_coupon(coupon)
    end
  end
end
