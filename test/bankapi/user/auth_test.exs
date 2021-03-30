defmodule Bankapi.User.AuthTest do
  use Bankapi.DataCase

  alias Bankapi.User
  alias Bankapi.User.Auth
  alias Bankapi.User.Create

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

  @valid_login_details {"12345678934", "12345678912"}
  @invalid_login_details {"1234567893", "1234567891"}

  describe "login/1" do
    test "create an user and login" do
      {:ok, %User{}} = Create.call(@valid_attrs_complete)
      login_result = Auth.login(@valid_login_details)
      assert {:ok, %User{}} = login_result
    end

    test "auth test invalid cpf and password" do
      login_result = Auth.login(@invalid_login_details)
      assert {:error, "User not found"} = login_result
    end
  end
end
