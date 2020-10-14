defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :api_auth do
    plug(Backend.Guardian.AuthPipeline)
  end

  scope "/api/swagger" do
    forward("/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :backend, swagger_file: "swagger.json")
  end

  scope "/api", BackendWeb do
    pipe_through(:api)
    get("/login", SessionController, :login)
    get("/callback", SessionController, :callback)
    get("/health", SessionController, :health)
  end

  scope "/api", BackendWeb do
    pipe_through([:api, :api_auth])

    resources "/companies", CompanyController, only: [:index, :delete] do
      resources("/users", UserController, except: [:new, :create, :edit])
    end

    get("/me", UserController, :me)
    get("/companies/:id/point", CompanyController, :show_point)

    get("/coupons/send", CouponController, :send)
    get("/companies/:company_id/coupons", CouponController, :show_by_company)
    get("/companies/:company_id/coupons/current", CouponController, :show_current)
    get("/companies/:company_id/coupons/next", CouponController, :show_next)
    resources("/coupons", CouponController, except: [:new, :edit])

    resources "/users", UserController, only: [] do
      resources("/health_datas", HealthDataController, except: [:new, :edit])
    end

    get("/companies/:company_id/health_datas", HealthDataController, :index_by_company)

    delete("/logout", SessionController, :logout)
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through([:fetch_session, :protect_from_forgery])
      live_dashboard("/dashboard", metrics: BackendWeb.Telemetry)
    end
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "back end"
      }
    }
  end
end
