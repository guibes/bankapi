defmodule Bankapi.User.UpdateTest do
  use Bankapi.DataCase
  alias Bankapi.User.{Create, Update}
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

  describe "call/1" do
    test "when all params are valid return an user with complete status" do

      {:ok, %User{id: user_id, user_code: user_code}} = Create.call(@valid_attrs_complete)
      update_attrs = %{
        "cpf" => "12345678934",
        "password" => "12345678912",
        "country" => "Brasil",
        "city" => "Vitorino",
        "birth_date" => "2000-01-01",
        "state" => "São Paulo",
        "name" => "Teste Teste",
        "email" => "tutaaa@tsaa.com"
    }
    {:ok, %User{}} = Update.call(update_attrs)

      user = Repo.get(User, user_id)
      assert %User{
        id: ^user_id,
        birth_date: ~D[2000-01-01],
        city: "Vitorino",
        country: "Brasil",
        cpf: "12345678934",
        email: "tutaaa@tsaa.com",
        gender: nil,
        name: "Teste Teste",
        password: nil, #because is virtual
        referral_code: nil,
        state: "São Paulo",
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
  end

end
