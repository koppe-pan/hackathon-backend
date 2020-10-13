defmodule BackendWeb.CouponController do
  use BackendWeb, :controller
  use PhoenixSwagger

  alias Backend.Coupons
  alias Backend.Coupons.Coupon

  action_fallback(BackendWeb.FallbackController)

  swagger_path :index do
    get("/api/coupons")
    summary("List coupons")
    description("List all coupons in the database")
    tag("Coupons")
    produces("application/json")

    response(200, "OK", Schema.ref(:CouponsResponse),
      example: %{
        data: [
          %{
            id: 1,
            cost: 42,
            description: "some description",
            created_at: "2010-04-17 14:00:00",
            life_time: "2010-04-17 14:00:00"
          }
        ]
      }
    )
  end

  def index(conn, _params) do
    coupons = Coupons.list_coupons()
    render(conn, "index.json", coupons: coupons)
  end

  swagger_path :create do
    post("/api/coupons")
    summary("Create coupon")
    description("Creates a new coupon")
    tag("Coupons")
    consumes("application/json")
    produces("application/json")

    parameter(:coupon, :body, Schema.ref(:CouponRequest), "The coupon details",
      example: %{
        coupon: %{cost: 42, description: "some description", life_time: "2010-04-17 14:00:00"}
      }
    )

    response(201, "Coupon created OK", Schema.ref(:CouponResponse),
      example: %{
        data: %{
          id: 1,
          cost: 42,
          description: "some description",
          created_at: "2010-04-17 14:00:00",
          life_time: "2010-04-17 14:00:00"
        }
      }
    )
  end

  def create(conn, %{"coupon" => coupon_params}) do
    with {:ok, %Coupon{} = coupon} <- Coupons.create_coupon(coupon_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.coupon_path(conn, :show, coupon))
      |> render("show.json", coupon: coupon)
    end
  end

  swagger_path :show do
    summary("Show Coupon")
    description("Show a coupon by ID")
    tag("Coupons")
    produces("application/json")
    parameter(:id, :path, :integer, "Coupon ID", required: true, example: 123)

    response(200, "OK", Schema.ref(:CouponResponse),
      example: %{
        data: %{
          id: 123,
          cost: 42,
          description: "some description",
          created_at: "2010-04-17 14:00:00",
          life_time: "2010-04-17 14:00:00"
        }
      }
    )
  end

  def show(conn, %{"id" => id}) do
    coupon = Coupons.get_coupon!(id)
    render(conn, "show.json", coupon: coupon)
  end

  swagger_path :update do
    put("/api/coupons/{id}")
    summary("Update coupon")
    description("Update all attributes of a coupon")
    tag("Coupons")
    consumes("application/json")
    produces("application/json")

    parameters do
      id(:path, :integer, "Coupon ID", required: true, example: 3)

      coupon(:body, Schema.ref(:CouponRequest), "The coupon details",
        example: %{
          coupon: %{cost: 42, description: "some description", life_time: "2010-04-17 14:00:00"}
        }
      )
    end

    response(200, "Updated Successfully", Schema.ref(:CouponResponse),
      example: %{
        data: %{
          id: 3,
          cost: 42,
          description: "some description",
          created_at: "2010-04-17 14:00:00",
          life_time: "2010-04-17 14:00:00"
        }
      }
    )
  end

  def update(conn, %{"id" => id, "coupon" => coupon_params}) do
    coupon = Coupons.get_coupon!(id)

    with {:ok, %Coupon{} = coupon} <- Coupons.update_coupon(coupon, coupon_params) do
      render(conn, "show.json", coupon: coupon)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/coupons/{id}")
    summary("Delete Coupon")
    description("Delete a coupon by ID")
    tag("Coupons")
    parameter(:id, :path, :integer, "Coupon ID", required: true, example: 3)
    response(203, "No Content - Deleted Successfully")
  end

  def delete(conn, %{"id" => id}) do
    coupon = Coupons.get_coupon!(id)

    with {:ok, %Coupon{}} <- Coupons.delete_coupon(coupon) do
      send_resp(conn, :no_content, "")
    end
  end

  def send(conn, _params) do
    Coupons.send_coupon()
    send_resp(conn, 200, "sended")
  end

  def swagger_definitions do
    %{
      Coupon:
        swagger_schema do
          title("Coupon")
          description("A coupon of the app")

          properties do
            id(:integer, "Coupon ID")
            cost(:string, "Coupon cost")
            description(:string, "Coupon description")
            life_time(:string, "Coupon life_time")
          end

          example(%{
            id: 123,
            cost: 42,
            description: "some description",
            created_at: "2010-04-17 14:00:00",
            life_time: "2010-04-17 14:00:00"
          })
        end,
      CouponRequest:
        swagger_schema do
          title("CouponRequest")
          description("POST body for creating a coupon")
          property(:coupon, Schema.ref(:Coupon), "The coupon details")

          example(%{
            coupon: %{
              cost: 42,
              description: "some description",
              life_time: "2010-04-17 14:00:00"
            }
          })
        end,
      CouponResponse:
        swagger_schema do
          title("CouponResponse")
          description("Response schema for single coupon")
          property(:data, Schema.ref(:Coupon), "The coupon details")
        end,
      CouponsResponse:
        swagger_schema do
          title("CouponsReponse")
          description("Response schema for multiple coupons")
          property(:data, Schema.array(:Coupon), "The coupons details")
        end
    }
  end
end
