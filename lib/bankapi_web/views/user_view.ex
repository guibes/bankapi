defmodule BankapiWeb.UserView do
  use BankapiWeb, :view
  alias Bankapi.User

  def render("create.json", %{
        user: %User{
          birth_date: birth_date,
          city: city,
          country: country,
          cpf: cpf,
          email: email,
          gender: gender,
          id: id,
          name: name,
          referral_code: referral_code,
          state: state,
          status: status,
          user_code: user_code
        }
      }) do
    case status do
      "complete" ->
        %{
          message: "User register complete",
          user: %{
            birth_date: birth_date,
            city: city,
            country: country,
            cpf: cpf,
            email: email,
            gender: gender,
            id: id,
            name: name,
            referral_code: referral_code,
            state: state,
            status: status,
            user_code: user_code
          }
        }

      "pending" ->
        %{
          message: "User register pending",
          user: %{
            birth_date: birth_date,
            city: city,
            country: country,
            cpf: cpf,
            email: email,
            gender: gender,
            id: id,
            name: name,
            referral_code: referral_code,
            state: state,
            status: status
          }
        }
    end
  end
end
