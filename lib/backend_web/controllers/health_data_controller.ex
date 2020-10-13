defmodule BackendWeb.HealthDataController do
  use BackendWeb, :controller
  use PhoenixSwagger

  alias Backend.HealthDatas
  alias Backend.HealthDatas.HealthData

  action_fallback(BackendWeb.FallbackController)

  swagger_path :index do
    get("/api/users/{user_id}/health_datas")
    summary("List health_datas")
    description("List all health_datas in the user")
    tag("HealthDatas")
    produces("application/json")
    parameter(:user_id, :path, :integer, "User ID", required: true, example: 3)

    response(200, "OK", Schema.ref(:HealthDatasResponse),
      example: %{
        data: [
          %{
            id: 1,
            comment: "some comment",
            date: ~D[2010-04-17],
            step: 42
          }
        ]
      }
    )
  end

  def index(conn, %{"user_id" => user_id}) do
    health_datas = HealthDatas.list_health_datas!(user_id)
    render(conn, "index.json", health_datas: health_datas)
  end

  swagger_path :index_by_company do
    get("/api/companies/{company_id}/health_datas")
    summary("List health_datas")
    description("List all health_datas in the company")
    tag("HealthDatas")
    produces("application/json")
    parameter(:company_id, :path, :integer, "User ID", required: true, example: 3)

    response(200, "OK", Schema.ref(:HealthDatasResponse),
      example: %{
        data: [
          %{
            id: 1,
            comment: "some comment",
            date: ~D[2010-04-17],
            step: 42
          }
        ]
      }
    )
  end

  def index_by_company(conn, %{"company_id" => company_id}) do
    health_datas = HealthDatas.list_health_datas_by_company!(company_id)
    render(conn, "index.json", health_datas: health_datas)
  end

  swagger_path :create do
    post("/api/users/{user_id}/health_datas")
    summary("Create health_data")
    description("Creates a new health_data")
    tag("HealthDatas")
    consumes("application/json")
    produces("application/json")

    parameter(:user_id, :path, :integer, "User ID", required: true, example: 3)

    parameter(:health_data, :body, Schema.ref(:HealthDataRequest), "The health_data details",
      example: %{
        health_data: %{comment: "some comment", date: ~D[2010-04-17], step: 42}
      }
    )

    response(201, "HealthData created OK", Schema.ref(:HealthDataResponse),
      example: %{
        data: %{
          id: 1,
          comment: "some comment",
          date: ~D[2010-04-17],
          step: 42
        }
      }
    )
  end

  def create(conn, %{"user_id" => user_id, "health_data" => health_data_params}) do
    with {:ok, %HealthData{} = health_data} <-
           HealthDatas.create_health_data!(user_id, health_data_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.user_health_data_path(conn, :show, user_id, health_data)
      )
      |> render("show.json", health_data: health_data)
    end
  end

  swagger_path :show do
    summary("Show HealthData")
    description("Show a health_data by ID")
    tag("HealthDatas")
    produces("application/json")
    parameter(:user_id, :path, :integer, "User ID", required: true, example: 3)
    parameter(:id, :path, :integer, "HealthData ID", required: true, example: 123)

    response(200, "OK", Schema.ref(:HealthDataResponse),
      example: %{
        data: %{
          id: 123,
          comment: "some comment",
          date: ~D[2010-04-17],
          step: 42
        }
      }
    )
  end

  def show(conn, %{"id" => id}) do
    health_data = HealthDatas.get_health_data!(id)
    render(conn, "show.json", health_data: health_data)
  end

  swagger_path :update do
    put("/api/users/{user_id}/health_datas/{id}")
    summary("Update health_data")
    description("Update all attributes of a health_data")
    tag("HealthDatas")
    consumes("application/json")
    produces("application/json")

    parameter(:user_id, :path, :integer, "User ID", required: true, example: 3)

    parameters do
      id(:path, :integer, "HealthData ID", required: true, example: 3)

      health_data(:body, Schema.ref(:HealthDataRequest), "The health_data details",
        example: %{
          health_data: %{comment: "some comment", date: ~D[2010-04-17], step: 42}
        }
      )
    end

    response(200, "Updated Successfully", Schema.ref(:HealthDataResponse),
      example: %{
        data: %{
          id: 3,
          comment: "some comment",
          date: ~D[2010-04-17],
          step: 42
        }
      }
    )
  end

  def update(conn, %{"id" => id, "health_data" => health_data_params}) do
    health_data = HealthDatas.get_health_data!(id)

    with {:ok, %HealthData{} = health_data} <-
           HealthDatas.update_health_data(health_data, health_data_params) do
      render(conn, "show.json", health_data: health_data)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/users/{user_id}/health_datas/{id}")
    summary("Delete HealthData")
    description("Delete a health_data by ID")
    tag("HealthDatas")
    parameter(:user_id, :path, :integer, "User ID", required: true, example: 3)
    parameter(:id, :path, :integer, "HealthData ID", required: true, example: 3)
    response(203, "No Content - Deleted Successfully")
  end

  def delete(conn, %{"id" => id}) do
    health_data = HealthDatas.get_health_data!(id)

    with {:ok, %HealthData{}} <- HealthDatas.delete_health_data(health_data) do
      send_resp(conn, :no_content, "")
    end
  end

  def swagger_definitions do
    %{
      HealthData:
        swagger_schema do
          title("HealthData")
          description("A health_data of the app")

          properties do
            id(:integer, "HealthData ID")
            comment(:string, "HealthData comment")
            date(:string, "HealthData date")
            step(:string, "HealthData step")
          end

          example(%{
            id: 123,
            comment: "some comment",
            date: ~D[2010-04-17],
            step: 42
          })
        end,
      HealthDataRequest:
        swagger_schema do
          title("HealthDataRequest")
          description("POST body for creating a health_data")
          property(:health_data, Schema.ref(:HealthData), "The health_data details")

          example(%{
            health_data: %{
              comment: "some comment",
              date: ~D[2010-04-17],
              step: 42
            }
          })
        end,
      HealthDataResponse:
        swagger_schema do
          title("HealthDataResponse")
          description("Response schema for single health_data")
          property(:data, Schema.ref(:HealthData), "The health_data details")
        end,
      HealthDatasResponse:
        swagger_schema do
          title("HealthDatasReponse")
          description("Response schema for multiple health_datas")
          property(:data, Schema.array(:HealthData), "The health_datas details")
        end
    }
  end
end
