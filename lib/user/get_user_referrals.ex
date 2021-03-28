defmodule Bankapi.User.GetUserReferrals do
  @moduledoc """
  Module to get user referrals, for example:
  If call the function call(), with a user_code, if the user code is valid,
  will return all users referrals.
  """
  alias Bankapi.{Repo, User}
  import Ecto.Query

  @doc """
  Function call to get all referrals
  """
  def call(%{"user_code" => user_code}) do
    check_user_code(user_code)
    |> handle_code_response()
  end

  defp check_user_code(user_code) do
    case Repo.get_by(User, user_code: user_code) do
      nil ->
        {:error, "invalid user code"}

      %User{status: "pending"} ->
        {:error, "pending user register"}

      %User{user_code: user_code, status: "complete"} ->
        {:ok, from(u in User, where: u.referral_code == ^user_code)}
    end
  end

  defp handle_code_response({:ok, query}) do
    query
    |> Repo.all()
    |> handle_response()
  end

  defp handle_code_response({:error, code}), do: {:error, code}
  defp handle_response(users), do: {:ok, users}
end
