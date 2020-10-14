defmodule BackendWeb.CompanyView do
  use BackendWeb, :view
  alias BackendWeb.CompanyView

  def render("index.json", %{companies: companies}) do
    render_many(companies, CompanyView, "company.json")
  end

  def render("show.json", %{company: company}) do
    render_one(company, CompanyView, "company.json")
  end

  def render("point.json", %{point: point}) do
    %{point: point}
  end

  def render("company.json", %{company: company}) do
    %{id: company.id}
  end
end
