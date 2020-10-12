defmodule Backend.HealthDatas do
  @moduledoc """
  The HealthDatas context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.HealthDatas.HealthData
  alias Backend.Users

  @doc """
  Returns the list of health_datas.

  ## Examples

      iex> list_health_datas()
      [%HealthData{}, ...]

  """
  def list_health_datas do
    Repo.all(HealthData)
  end

  def list_health_datas!(user_id) do
    Users.get_user!(user_id)
    |> Repo.preload(:health_datas)
    |> Map.get(:health_datas)
  end

  def list_health_datas_by_company!(company_id) do
    Users.list_users!(company_id)
    |> Enum.flat_map(fn user -> list_health_datas!(user.id) end)
  end

  @doc """
  Gets a single health_data.

  Raises `Ecto.NoResultsError` if the Health data does not exist.

  ## Examples

      iex> get_health_data!(123)
      %HealthData{}

      iex> get_health_data!(456)
      ** (Ecto.NoResultsError)

  """
  def get_health_data!(id), do: Repo.get!(HealthData, id)

  def get_health_data_after_date!(user_id, date) do
    Users.get_user!(user_id)
    |> Repo.preload(:health_datas)
    |> Map.get(:health_datas)
  end

  @doc """
  Creates a health_data.

  ## Examples

      iex> create_health_data(%{field: value})
      {:ok, %HealthData{}}

      iex> create_health_data(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_health_data!(user_id, attrs \\ %{}) do
    Users.get_user!(user_id)
    |> Ecto.build_assoc(:health_datas)
    |> HealthData.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a health_data.

  ## Examples

      iex> update_health_data(health_data, %{field: new_value})
      {:ok, %HealthData{}}

      iex> update_health_data(health_data, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_health_data(%HealthData{} = health_data, attrs) do
    health_data
    |> HealthData.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a health_data.

  ## Examples

      iex> delete_health_data(health_data)
      {:ok, %HealthData{}}

      iex> delete_health_data(health_data)
      {:error, %Ecto.Changeset{}}

  """
  def delete_health_data(%HealthData{} = health_data) do
    Repo.delete(health_data)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking health_data changes.

  ## Examples

      iex> change_health_data(health_data)
      %Ecto.Changeset{data: %HealthData{}}

  """
  def change_health_data(%HealthData{} = health_data, attrs \\ %{}) do
    HealthData.changeset(health_data, attrs)
  end
end
