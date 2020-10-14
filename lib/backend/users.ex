defmodule Backend.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Users.User
  alias Backend.Companies

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def list_users!(company_id) do
    Companies.get_company!(company_id)
    |> Repo.preload(:users)
    |> Map.get(:users)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)
  def get_user_by_slack(slack_user_id), do: Repo.get_by(User, slack_user_id: slack_user_id)

  def get_or_create_user!(slack_company_id, slack_user_id, user_name) do
    case get_user_by_slack(slack_user_id) do
      user = %User{} ->
        {:ok, user}

      nil ->
        create_user_by_slack!(slack_company_id, %{slack_user_id: slack_user_id, name: user_name})
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(company_id, %{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user!(company_id, attrs \\ %{}) do
    Companies.get_company!(company_id)
    |> Ecto.build_assoc(:users)
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_by_slack!(slack_company_id, attrs \\ %{}) do
    with company = %Backend.Companies.Company{} <-
           Companies.get_company_by_slack(slack_company_id) do
      company
      |> Ecto.build_assoc(:users)
      |> User.changeset(attrs)
      |> Repo.insert()
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def authenticate_user(code) do
    with {:ok, token} <- get_token_by_code!(code) do
      HTTPoison.start()

      case HTTPoison.post(
             "https://slack.com/api/auth.test",
             "{\"body\": {\"token\": \"#{token}\"}}",
             [{"Content-Type", "application/json"}, {"Authorization", "Bearer " <> token}]
           ) do
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: body
         }} ->
          IO.inspect(body)

          case Jason.decode!(body) do
            %{
              "ok" => true,
              "team_id" => slack_company_id,
              "user" => user_name,
              "user_id" => slack_user_id
            } ->
              get_or_create_user!(slack_company_id, slack_user_id, user_name)

            %{"ok" => false, "error" => error} ->
              {:error, error}
          end

        {:ok, %HTTPoison.Response{status_code: 404}} ->
          {:error, "404 in token"}

        {:error, %HTTPoison.Error{reason: reason}} ->
          {:error, reason}
      end
    end
  end

  defp get_token_by_code!(code) do
    HTTPoison.start()

    params = [
      code: code,
      client_id: Application.get_env(:backend, :slack_id),
      client_secret: Application.get_env(:backend, :slack_secret)
    ]

    case HTTPoison.post(
           "https://slack.com/api/oauth.v2.access",
           {:form, params}
         ) do
      {:ok,
       %HTTPoison.Response{
         status_code: 200,
         body: body
       }} ->
        case Jason.decode!(body) do
          %{
            "ok" => true,
            "team" => %{"id" => slack_company_id},
            "authed_user" => %{"access_token" => token}
          } ->
            with {:ok, _} <-
                   Backend.Companies.ensure_company_exist!(slack_company_id, token),
                 do: {:ok, token}

          %{"ok" => false, "error" => error} ->
            {:error, error}
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "404 in code"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def reset_point do
    list_users()
    |> Enum.each(fn user -> update_user(user, %{point: 0}) end)
  end
end
