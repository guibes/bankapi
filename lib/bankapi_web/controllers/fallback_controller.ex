defmodule BankapiWeb.FallbackController do
  use BankapiWeb, :controller

  def call(conn, {:error, result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(BankapiWeb.ErrorView)
    |> render("400.json", result: result)
  end
end
