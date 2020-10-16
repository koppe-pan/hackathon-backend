defmodule BackendWeb.HealthDataView do
  use BackendWeb, :view
  alias BackendWeb.HealthDataView

  def render("index.json", %{health_datas: health_datas}) do
    render_many(health_datas, HealthDataView, "health_data.json")
  end

  def render("show.json", %{health_data: health_data}) do
    render_one(health_data, HealthDataView, "health_data.json")
  end

  def render("health_data.json", %{health_data: health_data}) do
    %{
      id: health_data.id,
      date: health_data.date,
      step: health_data.step,
      sleep_begin: health_data.sleep_begin,
      sleep_end: health_data.sleep_end,
      comment: health_data.comment
    }
  end
end
