defmodule BackendWeb.UserView do
  use BackendWeb, :view
  alias BackendWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, name: user.name, point: user.point, role: user.role}
  end

  def render("me.json", %{user: user, company_id: company_id}) do
    %{company_id: company_id, id: user.id, name: user.name, point: user.point, role: user.role}
  end
end
