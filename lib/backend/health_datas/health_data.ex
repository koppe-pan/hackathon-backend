defmodule Backend.HealthDatas.HealthData do
  use Ecto.Schema
  import Ecto.Changeset

  schema "health_datas" do
    field(:comment, :string)
    field(:date, :date, unique: true)
    field(:step, :integer)
    field(:sleep_begin, :time)
    field(:sleep_end, :time)
    belongs_to(:user, Backend.Users.User)

    timestamps()
  end

  @doc false
  def changeset(health_data, attrs) do
    health_data
    |> cast(attrs, [:date, :step, :comment, :sleep_begin, :sleep_end])
    |> validate_required([:date, :step, :comment, :sleep_begin, :sleep_end])
  end
end
