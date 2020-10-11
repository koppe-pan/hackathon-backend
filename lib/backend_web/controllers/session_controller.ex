defmodule BackendWeb.SessionController do
  use BackendWeb, :controller
  use PhoenixSwagger

  alias Backend.Users
  alias Backend.Guardian

  action_fallback BackendWeb.FallbackController

  swagger_path :login do
    post("/api/login")
    summary("login")

    description(
      "login with slack token. in order to authorize, you need to add response token to authorization Bearer header."
    )

    tag("Sessions")

    parameter(:token, :body, "some slack token", "The slack token",
      example: %{
        token: "some slack token"
      }
    )

    response(
      200,
      "OK",
      swagger_schema do
        properties do
          token(:string, "jwt token")
        end
      end,
      example: %{
        data: %{
          token: "some jwt token"
        }
      }
    )
  end

  def login(conn, %{"token" => token}) do
    case Users.authenticate_user(token) do
      {:ok, user} ->
        {:ok, jwt, _claims} = Guardian.encode_and_sign(user)

        conn
        |> render("login.json", user: user, jwt: jwt)

      {:error, _changeset} ->
        conn
        |> put_status(401)
        |> render("error.json", message: "Could not login")
    end
  end

  swagger_path :logout do
    PhoenixSwagger.Path.delete("/api/logout")
    summary("logout")
    description("logout")
    tag("Sessions")
    response(203, "No Content - Deleted Successfully")
  end

  def logout(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    {:ok, _claims} = Guardian.revoke(jwt)

    conn
    |> send_resp(:no_content, "")
  end

  def swagger_definitions do
    %{
      Session:
        swagger_schema do
          title("Session")
          description("A session of the app")
        end
    }
  end
end
