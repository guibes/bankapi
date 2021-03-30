defmodule Bankapi.User.GetUserReferralsTest do
  use Bankapi.DataCase
  alias Bankapi.User.{Create, GetUserReferrals}
  alias Bankapi.User

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
    test "when receive a user code, return all referrals" do
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
      {:ok, _} = Create.call(new_user)
      {:ok, [%User{referral_code: referral_code}]} = GetUserReferrals.call(%{"user_code" => user_code})
      assert ^user_code = referral_code
    end
  end
end
