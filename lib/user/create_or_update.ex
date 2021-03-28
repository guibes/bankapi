defmodule Bankapi.User.CreateorUpdate do
  @moduledoc """
  Module to create or update a user in the database.
  """
  alias Bankapi.{Repo, User}

  @doc """
  Function to create or update a user in the database using Repo.
  Case the referral code not exists or user status of code is pending, return errors.
  """

  def call(params) do
    %{"cpf" => cpf} = params

    case Repo.get_by(User, cpf: cpf) do
      nil -> User.changeset(params)
      %User{} = user -> User.update_changeset(user, params)
    end
    |> validate_referral_code()
    |> Repo.insert_or_update()
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
        Ecto.Changeset.add_error(changeset, :referral_code, "invalid referral_code")

      %User{status: "pending"} ->
        Ecto.Changeset.add_error(changeset, :referral_code, "user of referral_code is pending")

      _ ->
        changeset
    end
  end
end
