defmodule Backend.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field(:slack_company_id, :string, unique: true)
    has_many(:users, Backend.Users.User)

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:slack_company_id])
    |> validate_required([:slack_company_id])
  end
end
