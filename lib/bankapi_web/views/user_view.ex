defmodule BankapiWeb.UserView do
  use BankapiWeb, :view
  alias Bankapi.User
  alias BankapiWeb.UserView

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

  def render("get_user_referral.json", %{
        user: %User{
          id: id,
          name: name
        }
      }) do
    %{
      id: id,
      name: name
    }
  end

  def render("get_all_referrals.json", %{users: users}) do
    %{
      referrals: render_many(users, UserView, "get_user_referral.json"),
      message: "Listing all referrals"
    }
  end
end
