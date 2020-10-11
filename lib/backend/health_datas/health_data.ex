defmodule Backend.HealthDatas.HealthData do
  use Ecto.Schema
  import Ecto.Changeset

  schema "health_datas" do
    field :comment, :string
    field :date, :date
    field :step, :integer
    belongs_to :user, Backend.Users.User

    timestamps()
  end

  @doc false
  def changeset(health_data, attrs) do
    health_data
    |> cast(attrs, [:date, :step, :comment])
    |> validate_required([:date, :step, :comment])
  end
end
