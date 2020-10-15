defmodule Backend.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:slack_user_id, :string, unique: true)
    field(:name, :string)
    field(:point, :integer, default: 0)
    field(:role, :string)
    has_many(:health_datas, Backend.HealthDatas.HealthData)
    belongs_to(:company, Backend.Companies.Company)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :slack_user_id, :point, :role])
    |> validate_required([:name, :slack_user_id])
  end
end
