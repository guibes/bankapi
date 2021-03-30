defmodule Bankapi.User.Auth do
  @moduledoc """
  Module to make a connection to database using cpf and password
  """
  alias Bankapi.{Repo, User}

  @doc """
  Function to login with cpf and passoword
    ### Input
      login({cpf, password})
    ### Reponse
      {:ok, %User{}}
    ### Error
      {:error, "Insert user and password"}
      {:error, "User not found"}
      {:error, message}

      Generic message is a string with another error.
  """
  def login({cpf, password}) do
    User
    |> Repo.get_by(cpf_hash: cpf)
    |> handle_response(password)
  end

  def login(:error), do: {:error, "Insert user and password"}

  defp handle_response(%User{} = user, password) do
    user
    |> Argon2.check_pass(password)
    |> handle_argon_response()
  end

  defp handle_response(_, _password), do: {:error, "User not found"}

  defp handle_argon_response({:ok, user}), do: {:ok, user}

  defp handle_argon_response({:error, message}), do: {:error, message}
end
