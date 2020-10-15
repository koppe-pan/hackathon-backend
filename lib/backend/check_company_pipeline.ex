defmodule Backend.CheckCompanyPipeline do
  def init(default), do: default

  def call(%Plug.Conn{params: %{"company_id" => company_id}} = conn, _default) do
    case Guardian.Plug.current_resource(conn) do
      user = %Backend.Users.User{} ->
        if user.company_id == String.to_integer(company_id) do
          conn
        else
          raise(Plug.BadRequestError)
        end

      _ ->
        conn
    end
  end

  def call(conn, _params) do
    conn
  end
end
