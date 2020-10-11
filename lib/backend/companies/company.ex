defmodule Backend.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    has_many :users, Backend.Users.User
    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [])
    |> validate_required([])
  end
end
