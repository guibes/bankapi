defmodule BankapiWeb.Controllers.AuthController do
  import Plug.Conn
  alias Bankapi.User

  def auth(conn) do
    with login_data <- Plug.BasicAuth.parse_basic_auth(conn),
         {:ok, %User{} = user} <- Bankapi.User.Auth.login(login_data) do
      assign(conn, :current_user, user)
      {:ok, user}
    else
      {:error, message} -> {:unauthorized, message}
    end
  end
end

#
