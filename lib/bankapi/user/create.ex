defmodule Bankapi.User.Create do
  @moduledoc """
  Module to update a user in the database.
  """
  alias Bankapi.{Repo, User}
  alias Bankapi.User.ReferralCode

  @doc """
  Function to update a user in the database using Repo.
  Case the referral code not exists or user status of code is pending, return errors.
  """

  def call(params) do
    params
    |> User.changeset()
    |> ReferralCode.validate_referral_code()
    |> Repo.insert()
  end
end
