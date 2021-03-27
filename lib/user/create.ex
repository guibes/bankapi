defmodule Bankapi.User.Create do
  @moduledoc """
  Module to create a new user in the database.
  """
  alias Bankapi.{Repo, User}

  def create(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end
