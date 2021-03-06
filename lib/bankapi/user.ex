defmodule Bankapi.User do
  @moduledoc """
  Schema and changeset for the users table.
  """
  use Ecto.Schema

  alias Bankapi.UserCode
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_params [:cpf, :password]
  @optional_params [:name, :email, :birth_date, :city, :state, :country]
  @other_params [:gender, :referral_code]

  @updateable_params [:name, :email, :city, :state, :country, :birth_date]

  schema "users" do
    field :name, Bankapi.Encrypted.Binary
    field :email, Bankapi.Encrypted.Binary
    field :email_hash, Cloak.Ecto.SHA256
    field :password, :string, virtual: true
    field :password_hash, :string
    field :cpf, Bankapi.Encrypted.Binary
    field :cpf_hash, Cloak.Ecto.SHA256
    field :birth_date, Bankapi.Encrypted.Date
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
    |> create_hashs()
    |> unique_constraint(:cpf_hash)
    |> unique_constraint(:email_hash)
    |> validate_length(:password, min: 8)
    |> validate_length(:cpf, min: 11, max: 11)
    |> validate_length(:referral_code, min: 8, max: 8)
    |> validate_format(:cpf, cpf_regex())
    |> validate_format(:email, email_regex())
    |> create_code()
    |> validate_code_fields()
  end

  @doc """
  Changeset to update an user
  """
  def update_changeset(%Bankapi.User{status: status} = user, params) do
    user
    |> cast(params, cast_params(status))
    |> validate_length(:password, min: 8)
    |> validate_activated(status)
    |> validate_format(:email, email_regex())
    |> unique_constraint(:email_hash)
    |> create_hashs()
    |> validate_code_fields()
  end

  defp create_hashs(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass, cpf: cpf, email: email}} ->
        changeset
        |> put_change(:cpf_hash, cpf)
        |> put_change(:email_hash, email)
        |> put_change(:password_hash, Argon2.hash_pwd_salt(pass))

      %Ecto.Changeset{changes: %{cpf: cpf, password: pass}} ->
        changeset
        |> put_change(:cpf_hash, cpf)
        |> put_change(:password_hash, Argon2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end

  defp validate_activated(changeset, status) do
    case status do
      "complete" -> validate_required(changeset, @updateable_params)
      _ -> changeset
    end
  end

  defp cast_params(status) do
    case status do
      "pending" -> @required_params ++ @updateable_params ++ @other_params
      _ -> @required_params ++ @updateable_params
    end
  end

  defp validate_code_fields(changeset) do
    case validate_required(changeset, @optional_params).errors do
      [] -> put_change(changeset, :status, "complete")
      _ -> put_change(changeset, :status, "pending")
    end
  end

  defp create_code(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        changeset
        |> put_change(:user_code, UserCode.generate())

      _ ->
        changeset
    end
  end

  defp email_regex() do
    ~r/^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i
  end

  defp cpf_regex() do
    ~r/([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})/
  end
end
