defmodule Bankapi.User do
  @moduledoc """
  Schema and changeset for the users table.
  """
  use Ecto.Schema

  alias Bankapi.UserCode
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_params [:cpf]
  @optional_params [:name, :email, :birth_date, :city, :state, :country]
  @other_params [:gender, :referral_code]

  @updateable_params [:name, :email, :city, :state, :country, :gender]

  schema "users" do
    field :name, :string
    field :email, :string
    field :cpf, :string
    field :birth_date, :date
    field :gender, :string
    field :city, :string
    field :state, :string
    field :country, :string
    field :referral_code, :string
    field :user_code, :string
    field :status, :string

    timestamps()
  end

  @doc """
  Changeset for insert a new user
  """

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params ++ @optional_params ++ @other_params)
    |> validate_required(@required_params)
    |> validate_length(:cpf, min: 11, max: 11)
    |> validate_length(:referral_code, min: 8, max: 8)
    |> validate_format(:cpf, cpf_regex())
    |> validate_format(:email, email_regex())
    |> unique_constraint([:cpf, :email])
    |> create_user_code()
  end

  @doc """
  Changeset to update an user
  """
  def update_changeset(params) do
    %__MODULE__{}
    |> cast(params, @updateable_params)
    |> validate_format(:email, email_regex())
    |> unique_constraint([:email])
  end

  defp create_user_code(changeset) do
    case validate_required(changeset, @required_params ++ @optional_params).errors do
      [] ->
        changeset
        |> put_change(:user_code, UserCode.generate())
        |> put_change(:status, "complete")

      _ ->
        put_change(changeset, :status, "pending")
    end
  end

  defp email_regex() do
    ~r/^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i
  end

  defp cpf_regex() do
    ~r/([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})/
  end
end
