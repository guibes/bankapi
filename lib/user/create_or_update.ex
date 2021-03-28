defmodule Bankapi.User.CreateorUpdate do
  @moduledoc """
  Module to create or update a user in the database.
  """
  alias Bankapi.{Repo, User}

  def create_or_update(params) do
    %{"cpf" => cpf} = params

    case Repo.get_by(User, cpf: cpf) do
      nil -> User.changeset(params)
      %User{} = user -> User.update_changeset(user, params)
    end
    |> Repo.insert_or_update()
  end
end
