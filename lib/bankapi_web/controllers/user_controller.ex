defmodule BankapiWeb.UserController do
  @moduledoc """
  User controller module, responsable to create, update and list all referral_codes
  """
  use BankapiWeb, :controller
  alias Bankapi.User

  action_fallback BankapiWeb.FallbackController

  @doc """
  Function to create or update a user, this function render the json of the output too.
  """
  def create_or_update(conn, params) do
    with {:ok, %User{} = user} <- Bankapi.create_or_update_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end

  @doc """
  Function to get all referral users by a code.
  """
  def get_all_users_by_referral(conn, params) do
    with {:ok, users} <- Bankapi.get_user_referrals(params) do
      conn
      |> put_status(:ok)
      |> render("get_all_referrals.json", users: users)
    end
  end
end
