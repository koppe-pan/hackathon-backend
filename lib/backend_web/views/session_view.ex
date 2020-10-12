defmodule BackendWeb.SessionView do
  use BackendWeb, :view
  alias BackendWeb.SessionView

  def render("login.json", %{user: _user, jwt: jwt}) do
    %{data: %{token: jwt}}
  end

  def render("401.json", %{message: message}) do
    %{
      errors: %{
        detail: message
      }
    }
  end
end
