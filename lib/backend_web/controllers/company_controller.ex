defmodule BackendWeb.CompanyController do
  use BackendWeb, :controller
  use PhoenixSwagger

  alias Backend.Companies
  alias Backend.Companies.Company

  action_fallback(BackendWeb.FallbackController)

  swagger_path :index do
    get("/api/companies")
    summary("List companies")
    description("List all companies in the database")
    tag("Companys")
    produces("application/json")

    response(200, "OK", Schema.array(:Company),
      example: [
        %{
          id: 1
        }
      ]
    )
  end

  def index(conn, _params) do
    companies = Companies.list_companies()
    render(conn, "index.json", companies: companies)
  end

  @doc """
  swagger_path :create do
    post("/api/companies")
    summary("Create company")
    description("Creates a new company")
    tag("Companys")
    consumes("application/json")
    produces("application/json")

    parameter(:company, :body, Schema.ref(:CompanyRequest), "The company details",
      example: %{
        company: %{}
      }
    )

    response(201, "Company created OK", Schema.ref(:CompanyResponse),
      example: %{
        data: %{
          id: 1
        }
      }
    )
  end

  def create(conn, %{"company" => company_params}) do
    with {:ok, %Company{} = company} <- Companies.create_company(company_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.company_path(conn, :show, company))
      |> render("show.json", company: company)
    end
  end

  swagger_path :show do
    summary("Show Company")
    description("Show a company by ID")
    tag("Companys")
    produces("application/json")
    parameter(:id, :path, :integer, "Company ID", required: true, example: 123)

    response(200, "OK", Schema.ref(:CompanyResponse),
      example: %{
        data: %{
          id: 123
        }
      }
    )
  end

  def show(conn, %{"id" => id}) do
    company = Companies.get_company!(id)
    render(conn, "show.json", company: company)
  end

  swagger_path :update do
    put("/api/companies/{id}")
    summary("Update company")
    description("Update all attributes of a company")
    tag("Companys")
    consumes("application/json")
    produces("application/json")

    parameters do
      id(:path, :integer, "Company ID", required: true, example: 3)

      company(:body, Schema.ref(:CompanyRequest), "The company details",
        example: %{
          company: %{}
        }
      )
    end

    response(200, "Updated Successfully", Schema.ref(:CompanyResponse),
      example: %{
        data: %{
          id: 3
        }
      }
    )
  end

  def update(conn, %{"id" => id, "company" => company_params}) do
    company = Companies.get_company!(id)

    with {:ok, %Company{} = company} <- Companies.update_company(company, company_params) do
      render(conn, "show.json", company: company)
    end
  end
  """

  swagger_path :show_point do
    summary("Sum of company points")
    tag("Companys")
    parameter(:id, :path, :integer, "Company ID", required: true, example: 3)

    response(
      200,
      "OK",
      Schema.ref(:CompanyPoint),
      example: %{
        point: 800
      }
    )
  end

  def show_point(conn, %{"id" => id}) do
    point = Companies.sum_point(id)
    render(conn, "point.json", point: point)
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/companies/{id}")
    summary("Delete Company")
    description("Delete a company by ID")
    tag("Companys")
    parameter(:id, :path, :integer, "Company ID", required: true, example: 3)
    response(203, "No Content - Deleted Successfully")
  end

  def delete(conn, %{"id" => id}) do
    company = Companies.get_company!(id)

    with {:ok, %Company{}} <- Companies.delete_company(company) do
      send_resp(conn, :no_content, "")
    end
  end

  def swagger_definitions do
    %{
      Company:
        swagger_schema do
          title("Company")
          description("A company of the app")

          properties do
            id(:integer, "Company ID")
          end

          example(%{
            id: 123
          })
        end,
      CompanyPoint:
        swagger_schema do
          title("CompanyPoint")
          description("sum of point")

          properties do
            point(:integer, "sum of point")
          end

          example(%{
            point: 800
          })
        end,
      CompanyRequest:
        swagger_schema do
          title("CompanyRequest")
          description("POST body for creating a company")
          property(:company, Schema.ref(:Company), "The company details")

          example(%{
            company: %{}
          })
        end
    }
  end
end
