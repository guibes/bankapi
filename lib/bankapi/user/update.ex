defmodule Bankapi.User.Update do
  @moduledoc """
  Module to update a user in the database.
  """
  alias Bankapi.{Repo, User}
  alias Bankapi.User.ReferralCode

  @doc """
  Function to update a user in the database using Repo.
  Case the referral code not exists or user status of code is pending, return errors.
  """

  def call(%{"cpf" => cpf} = params) do
    User
    |> Repo.get_by(cpf_hash: cpf)
    |> User.update_changeset(params)
    |> ReferralCode.validate_referral_code()
    |> Repo.update()
  end

  def call(_params), do: {:error, "insert a cpf"}

end
