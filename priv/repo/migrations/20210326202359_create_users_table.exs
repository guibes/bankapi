defmodule Bankapi.Repo.Migrations.CreateUsersTable do
  @moduledoc """
  Migration to create users table in the database
  """
  use Ecto.Migration

  @doc """
  Function to create the users table in the database.

  Contraints to check:
  - birth_date is smaller than today
  - cpf only have digits in string

  Reference of fields:
  - name, the user's name
  - email, the user's email address
  - cpf, the user's brazilian CPF ID, accepts only digits
  - birth_date, the user's birth date, must be less or equal than today
  - gender, the user's gender, gender can be null.
  - city, the user's city
  - state, the user's state or province
  - country, the user's country
  - referral_code, the user's referral, used to indicate the platform to another users.
  """
  def up do
    create table(:users) do
      add :name, :binary
      add :email, :binary
      add :email_hash, :binary
      add :cpf, :binary, comment: "CPF is a brazilian citizen ID"
      add :cpf_hash, :binary
      add :birth_date, :binary
      add :gender, :string
      add :city, :string
      add :state, :string
      add :country, :string
      add :status, :string, comment: "Status of the user, can be: pending or complete"
      add :referral_code, :string, size: 8, comment: "Referral of the user_code"
      add :user_code, :string, size: 8, comment: "User code to use in referral"

      timestamps()
    end

    create unique_index(:users, [:cpf_hash])
    create unique_index(:users, [:email_hash])
    create unique_index(:users, [:user_code])
  end

  @doc """
  Delete the tables and constraints
  """
  def down do
    drop table("users")
  end
end
