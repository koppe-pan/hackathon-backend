defmodule BackendWeb.UserController do
  use BackendWeb, :controller
  use PhoenixSwagger

  alias Backend.Users
  alias Backend.Users.User

  action_fallback(BackendWeb.FallbackController)

  swagger_path :index do
    get("/api/companies/{company_id}/users")
    summary("List users")
    description("List all users in the database")
    tag("Users")
    produces("application/json")
    parameter(:company_id, :path, :integer, "Company ID", required: true, example: 3)

    response(200, "OK", Schema.array(:User),
      example: [
        %{id: 1, name: "some name", point: 42, role: "some role"}
      ]
    )
  end

  def index(conn, %{"company_id" => company_id}) do
    users = Users.list_users!(company_id)
    render(conn, "index.json", users: users)
  end

  @doc """
  swagger_path :create do
    post("/api/companies/{company_id}/users")
    summary("Create user")
    description("Creates a new user")
    tag("Users")
    consumes("application/json")
    produces("application/json")

    parameter(:user, :body, Schema.ref(:UserRequest), "The user details",
      example: %{
        user: %{name: "some name", role: "some role"}
      }
    )

    response(201, "User created OK", Schema.ref(:UserResponse),
      example: %{
        data: %{
          id: 1,
          name: "some name",
          point: 0,
          role: "some role"
        }
      }
    )
  end

  def create(conn, %{"company_id" => company_id, "user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user!(company_id, user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.company_user_path(conn, :show, company_id, user))
      |> render("show.json", user: user)
    end
  end
  """

  swagger_path :me do
    summary("Show Me")
    description("Show Me")
    tag("Users")
    produces("application/json")

    response(200, "OK", Schema.ref(:User),
      example: %{
        company_id: 1,
        id: 123,
        name: "some name",
        point: 42,
        role: "some role"
      }
    )
  end

  def me(conn, _attrs) do
    user = %User{} = Guardian.Plug.current_resource(conn)
    render(conn, "show.json", user: user)
  end

  swagger_path :show do
    summary("Show User")
    description("Show a user by ID")
    tag("Users")
    produces("application/json")
    parameter(:company_id, :path, :integer, "Company ID", required: true, example: 3)
    parameter(:id, :path, :integer, "User ID", required: true, example: 123)

    response(200, "OK", Schema.ref(:User),
      example: %{
        id: 123,
        name: "some name",
        point: 42,
        role: "some role"
      }
    )
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

  swagger_path :update do
    put("/api/companies/{company_id}/users/{id}")
    summary("Update user")
    description("Update all attributes of a user")
    tag("Users")
    consumes("application/json")
    produces("application/json")

    parameters do
      company_id(:path, :integer, "Company ID", required: true, example: 3)
      id(:path, :integer, "User ID", required: true, example: 3)

      user(:body, Schema.ref(:UserRequest), "The user details",
        example: %{
          user: %{name: "some name", point: 42, role: "some role"}
        }
      )
    end

    response(200, "Updated Successfully", Schema.ref(:User),
      example: %{
        id: 3,
        name: "some name",
        point: 42,
        role: "some role"
      }
    )
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/companies/{company_id}/users/{id}")
    summary("Delete User")
    description("Delete a user by ID")
    tag("Users")

    parameters do
      company_id(:path, :integer, "Company ID", required: true, example: 3)
      id(:path, :integer, "User ID", required: true, example: 3)
    end

    response(203, "No Content - Deleted Successfully")
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def swagger_definitions do
    %{
      User:
        swagger_schema do
          title("User")
          description("A user of the app")

          properties do
            company_id(:integer, "Company ID")
            id(:integer, "User ID")
            name(:string, "User name")
            point(:string, "User point")
            role(:string, "User role")
          end

          example(%{
            company_id: 1,
            id: 123,
            name: "some name",
            point: 42,
            role: "some role"
          })
        end,
      UserRequest:
        swagger_schema do
          title("UserRequest")
          description("POST body for creating a user")
          property(:user, Schema.ref(:User), "The user details")

          example(%{
            user: %{
              name: "some name",
              role: "some role"
            }
          })
        end
    }
  end
end
