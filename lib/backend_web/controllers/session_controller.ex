defmodule BackendWeb.SessionController do
  use BackendWeb, :controller
  use PhoenixSwagger

  alias Backend.Users
  alias Backend.Guardian

  action_fallback(BackendWeb.FallbackController)

  swagger_path :login do
    post("/api/login")
    summary("login")

    description(
      "login with slack token. in order to authorize, you need to add response token to authorization Bearer header."
    )

    tag("Sessions")

    parameter(:token, :body, Schema.ref(:SessionRequest), "The slack token",
      example: %{
        token: "some_slack_token"
      }
    )

    response(200, "OK", Schema.ref(:SessionResponse),
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

      {:error, reason} ->
        conn
        |> put_status(401)
        |> render("401.json", message: reason)
    end
  end

  swagger_path :health do
    summary("health check")

    description("for health check. always return 200")
    tag("Sessions")
    response(200, "OK")
  end

  def health(conn, _params) do
    send_resp(conn, 200, "OK")
  end

  def callback(conn, %{"code" => code}) do
    case Users.authenticate_user(code) do
      {:ok, user} ->
        {:ok, jwt, _claims} = Guardian.encode_and_sign(user)

        conn
        |> render("login.json", user: user, jwt: jwt)

      {:error, reason} ->
        conn
        |> put_status(401)
        |> render("401.json", message: reason)
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

          properties do
            token(:string, "JWT token")
          end

          example(%{
            token: "some_JWT_token"
          })
        end,
      SessionRequest:
        swagger_schema do
          title("SessionRequest")
          description("POST body for logging in")
          property(:token, :string, "The slack token")

          example(%{
            token: "some_slack_token"
          })
        end,
      SessionResponse:
        swagger_schema do
          title("SessionResponse")
          description("Response schema for session")
          property(:data, Schema.ref(:Session), "The session details")
        end
    }
  end
end
