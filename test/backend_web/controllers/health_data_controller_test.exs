defmodule BackendWeb.HealthDataControllerTest do
  use BackendWeb.ConnCase
  use PhoenixSwagger.SchemaTest, "priv/static/swagger.json"

  alias Backend.HealthDatas
  alias Backend.HealthDatas.HealthData

  @create_attrs %{
    comment: "some comment",
    date: ~D[2010-04-17],
    step: 42
  }
  @update_attrs %{
    comment: "some updated comment",
    date: ~D[2011-05-18],
    step: 43
  }
  @invalid_attrs %{comment: nil, date: nil, step: nil}

  def fixture(:health_data) do
    {:ok, health_data} = HealthDatas.create_health_data(@create_attrs)
    health_data
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all health_datas", %{conn: conn} do
      conn = get(conn, Routes.health_data_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create health_data" do
    test "renders health_data when data is valid", %{conn: conn} do
      conn = post(conn, Routes.health_data_path(conn, :create), health_data: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.health_data_path(conn, :show, id))

      assert %{
        "id" => id,
        "comment" => "some comment",
        "date" => "2010-04-17",
        "step" => 42
} = json_response(conn, 200)["data"]
  end

test "renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, Routes.health_data_path(conn, :create), health_data: @invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end
end

  describe "update health_data" do
    setup [:create_health_data]

    test "renders health_data when data is valid", %{conn: conn, health_data: %HealthData{id: id} = health_data} do
      conn = put(conn, Routes.health_data_path(conn, :update, health_data), health_data: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.health_data_path(conn, :show, id))

      assert %{
        "id" => id,
        "comment" => "some updated comment",
        "date" => "2011-05-18",
        "step" => 43
      } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, health_data: health_data} do
      conn = put(conn, Routes.health_data_path(conn, :update, health_data), health_data: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete health_data" do
    setup [:create_health_data]

    test "deletes chosen health_data", %{conn: conn, health_data: health_data} do
      conn = delete(conn, Routes.health_data_path(conn, :delete, health_data))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
                get(conn, Routes.health_data_path(conn, :show, health_data))
    end
  end
end

defp create_health_data(_) do
  health_data = fixture(:health_data)
    {:ok, health_data: health_data}
  end
end
