defmodule BankapiWeb.UserController do
  @moduledoc """
  User controller module, responsable to create, update and list all referral_codes
  """
  use BankapiWeb, :controller
  alias Bankapi.User
  alias BankapiWeb.Controllers.AuthController

  action_fallback BankapiWeb.FallbackController

  @doc """
  Function to create or update a user, this function render the json of the output too.
  """
  def create_or_update(conn, params) do
    case Bankapi.create_user(params) do
      {:ok, %User{} = user} ->
        conn
        |> put_status(:created)
        |> render("create.json", user: user)

      {:error, %{errors: [cpf_hash: {"has already been taken", _}]}} ->
        with {:ok, %User{cpf: cpf}} <- AuthController.auth(conn) do
          cond do
            cpf == params["cpf"] ->
              with {:ok, %User{} = user} <- Bankapi.update_user(params) do
                conn
                |> put_status(:ok)
                |> render("create.json", user: user)
              end

            cpf != params["cpf"] ->
              {:forbidden, "Do not have permission"}
          end
        end
    end
  end

  @doc """
  Function to get all referral users by a code.
  """
  def show_referrals(conn, params) do
    with {:ok, %User{user_code: user_code}} <- AuthController.auth(conn) do
      cond do
        user_code == params["user_code"] ->
          with {:ok, users} <- Bankapi.get_user_referrals(params) do
            conn
            |> put_status(:ok)
            |> render("get_all_referrals.json", users: users)
          end

        user_code != params["user_code"] ->
          {:forbidden, "Do not have permission"}
      end
    end
  end
end
