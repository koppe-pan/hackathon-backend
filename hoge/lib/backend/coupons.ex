defmodule Backend.Coupons do
  @moduledoc """
  The Coupons context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Coupons.Coupon

  @doc """
  Returns the list of coupons.

  ## Examples

      iex> list_coupons()
      [%Coupon{}, ...]

  """
  def list_coupons do
    Repo.all(Coupon)
  end

  @doc """
  Gets a single coupon.

  Raises `Ecto.NoResultsError` if the Coupon does not exist.

  ## Examples

      iex> get_coupon!(123)
      %Coupon{}

      iex> get_coupon!(456)
      ** (Ecto.NoResultsError)

  """
  def get_coupon!(id), do: Repo.get!(Coupon, id)

  @doc """
  Creates a coupon.

  ## Examples

      iex> create_coupon(%{field: value})
      {:ok, %Coupon{}}

      iex> create_coupon(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_coupon(attrs \\ %{}) do
    %Coupon{}
    |> Coupon.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a coupon.

  ## Examples

      iex> update_coupon(coupon, %{field: new_value})
      {:ok, %Coupon{}}

      iex> update_coupon(coupon, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_coupon(%Coupon{} = coupon, attrs) do
    coupon
    |> Coupon.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a coupon.

  ## Examples

      iex> delete_coupon(coupon)
      {:ok, %Coupon{}}

      iex> delete_coupon(coupon)
      {:error, %Ecto.Changeset{}}

  """
  def delete_coupon(%Coupon{} = coupon) do
    Repo.delete(coupon)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking coupon changes.

  ## Examples

      iex> change_coupon(coupon)
      %Ecto.Changeset{data: %Coupon{}}

  """
  def change_coupon(%Coupon{} = coupon, attrs \\ %{}) do
    Coupon.changeset(coupon, attrs)
  end

  def send_coupon() do
    Backend.Companies.list_companies()
    |> Enum.each(fn company -> send_coupon(company) end)
  end

  def send_coupon(%{id: company_id, token: token} = _company) do
    with {:ok, coupon} <-
           company_id
           |> list_users!()
           |> Enum.reduce(0, fn user, s -> user.point + s end)
           |> select_coupon() do
    HTTPoison.start()

    HTTPoison.post(
           "https://slack.com/api/chat.postMessage",
           "{\"body\": {\"channel\": \"#random\", \"text\": \"#{coupon.description}\"}}",
      [{"Content-Type", "application/json"}, {"Authorization", "Bearer "<>token}])
  end

  def select_coupon(sum) do
    from(c in Coupon, where: c.cost <= sum, order_by: [asc: c.cost])
    |> Repo.one()
  end
end
