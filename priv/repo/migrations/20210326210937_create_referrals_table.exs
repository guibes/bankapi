defmodule Bankapi.Repo.Migrations.CreateReferralsTable do
  @moduledoc """
  Migration to create referrals table in the database
  """
  use Ecto.Migration

  @doc """
  Create table with Referrals

  Reference of fields:
  - user_id, the id of new user
  - referral_code, the referral code of the user that previously are registered
  """
  def up do
    create table(:referrals) do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
      add :referral_code, references(:users, column: :referral_code, type: :string, on_delete: :delete_all, size: 8)

      timestamps()
    end
  end

  @doc """
  Delete the table
  """
  def down do
    drop table(:referrals)
  end
end
