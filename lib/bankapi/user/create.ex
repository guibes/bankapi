defmodule Bankapi.User.Create do
  @moduledoc """
  Module to update a user in the database.
  """
  alias Bankapi.{Repo, User}
  import Ecto.Changeset

  @doc """
  Function to update a user in the database using Repo.
  Case the referral code not exists or user status of code is pending, return errors.
  """

  def call(params) do
    params
    |> User.changeset()
    |> validate_referral_code()
    |> Repo.insert()
  end

  defp validate_referral_code(changeset) do
    case changeset.changes do
      %{referral_code: referral_code} -> handle_referral(changeset, referral_code)
      %{} -> changeset
    end
  end

  defp handle_referral(changeset, referral_code) do
    case Repo.get_by(User, user_code: referral_code) do
      nil ->
        add_error(changeset, :referral_code, "invalid referral_code")

      %User{status: "pending"} ->
        add_error(changeset, :referral_code, "user of referral_code is pending")

      _ ->
        changeset
    end
  end
end
