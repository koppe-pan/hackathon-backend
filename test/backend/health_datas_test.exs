defmodule Backend.HealthDatasTest do
  use Backend.DataCase

  alias Backend.HealthDatas

  describe "health_datas" do
    alias Backend.HealthDatas.HealthData

    @valid_attrs %{comment: "some comment", date: ~D[2010-04-17], step: 42}
    @update_attrs %{comment: "some updated comment", date: ~D[2011-05-18], step: 43}
    @invalid_attrs %{comment: nil, date: nil, step: nil}

    def health_data_fixture(attrs \\ %{}) do
      {:ok, health_data} =
        attrs
        |> Enum.into(@valid_attrs)
        |> HealthDatas.create_health_data()

      health_data
    end

    test "list_health_datas/0 returns all health_datas" do
      health_data = health_data_fixture()
      assert HealthDatas.list_health_datas() == [health_data]
    end

    test "get_health_data!/1 returns the health_data with given id" do
      health_data = health_data_fixture()
      assert HealthDatas.get_health_data!(health_data.id) == health_data
    end

    test "create_health_data/1 with valid data creates a health_data" do
      assert {:ok, %HealthData{} = health_data} = HealthDatas.create_health_data(@valid_attrs)
      assert health_data.comment == "some comment"
      assert health_data.date == ~D[2010-04-17]
      assert health_data.step == 42
    end

    test "create_health_data/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = HealthDatas.create_health_data(@invalid_attrs)
    end

    test "update_health_data/2 with valid data updates the health_data" do
      health_data = health_data_fixture()
      assert {:ok, %HealthData{} = health_data} = HealthDatas.update_health_data(health_data, @update_attrs)
      assert health_data.comment == "some updated comment"
      assert health_data.date == ~D[2011-05-18]
      assert health_data.step == 43
    end

    test "update_health_data/2 with invalid data returns error changeset" do
      health_data = health_data_fixture()
      assert {:error, %Ecto.Changeset{}} = HealthDatas.update_health_data(health_data, @invalid_attrs)
      assert health_data == HealthDatas.get_health_data!(health_data.id)
    end

    test "delete_health_data/1 deletes the health_data" do
      health_data = health_data_fixture()
      assert {:ok, %HealthData{}} = HealthDatas.delete_health_data(health_data)
      assert_raise Ecto.NoResultsError, fn -> HealthDatas.get_health_data!(health_data.id) end
    end

    test "change_health_data/1 returns a health_data changeset" do
      health_data = health_data_fixture()
      assert %Ecto.Changeset{} = HealthDatas.change_health_data(health_data)
    end
  end
end
