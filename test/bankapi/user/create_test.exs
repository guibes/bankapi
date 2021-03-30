defmodule Bankapi.User.CreateTest do
  use Bankapi.DataCase
  alias Bankapi.User.Create
  alias Bankapi.{User, Repo}

  @valid_attrs_complete %{
    cpf: "12345678934",
    password: "12345678912",
    country: "USA",
    city: "Vitorino",
    birth_date: "2000-01-01",
    state: "Paraná",
    name: "Teste Teste",
    email: "tutaaa@tsaa.com"
  }

  @valid_attrs_pending %{
    cpf: "12345678934",
    password: "12345678912"
  }

  @valid_attrs_referral_wrong %{
    cpf: "12345678934",
    password: "12345678912",
    country: "USA",
    city: "Vitorino",
    birth_date: "2000-01-01",
    state: "Paraná",
    name: "Teste Teste",
    referral_code: "abcdefgh",
    email: "tutaaa@tsaa.com"
  }

  describe "call/1" do
    test "when all params are valid return an user with complete status" do
      {:ok, %User{id: user_id, user_code: user_code, password_hash: password_hash}} =
        Create.call(@valid_attrs_complete)

      user = Repo.get(User, user_id)

      assert %User{
               id: ^user_id,
               birth_date: ~D[2000-01-01],
               city: "Vitorino",
               country: "USA",
               cpf: "12345678934",
               email: "tutaaa@tsaa.com",
               gender: nil,
               name: "Teste Teste",
               # because is virtual
               password: nil,
               password_hash: ^password_hash,
               referral_code: nil,
               state: "Paraná",
               status: "complete",
               user_code: ^user_code
             } = user
    end

    test "when all params are valid and referral_code user is complete" do
      {:ok, %User{user_code: user_code}} = Create.call(@valid_attrs_complete)

      new_user = %{
        cpf: "12345678935",
        password: "12345678912",
        country: "USA",
        city: "Vitorino",
        birth_date: "2000-01-01",
        state: "Paraná",
        name: "Teste Teste",
        email: "aaaa@aaaa.com",
        referral_code: user_code
      }

      {:ok, new_user_response} = Create.call(new_user)
      assert %User{referral_code: ^user_code} = new_user_response
    end

    test "when all params are valid but referral_code is invalid" do
      {:error, changeset} = Create.call(@valid_attrs_referral_wrong)

      assert %{referral_code: ["invalid referral_code"]} = errors_on(changeset)
      refute changeset.valid?
    end

    test "when all params are valid but user is pending" do
      {:ok, %User{user_code: user_code}} = Create.call(@valid_attrs_pending)

      new_user = %{
        cpf: "12345678935",
        password: "12345678912",
        referral_code: user_code
      }

      {:error, changeset} = Create.call(new_user)
      assert %{referral_code: ["user of referral_code is pending"]} = errors_on(changeset)
      refute changeset.valid?
    end
  end
end
