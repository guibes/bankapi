defmodule BankapiWeb.FallbackController do
  use BankapiWeb, :controller

  def call(conn, {:forbidden, result}) do
    conn
    |> put_status(:forbidden)
    |> put_view(BankapiWeb.ErrorView)
    |> render("403.json", result: result)
  end

  def call(conn, {:unauthorized, result}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(BankapiWeb.ErrorView)
    |> render("401.json", result: result)
  end

  def call(conn, {:not_found, result}) do
    conn
    |> put_status(:not_found)
    |> put_view(BankapiWeb.ErrorView)
    |> render("404.json", result: result)
  end

  def call(conn, {:error, result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(BankapiWeb.ErrorView)
    |> render("400.json", result: result)
  end
end
