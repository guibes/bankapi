defmodule BankapiWeb.Router do
  use BankapiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BankapiWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", BankapiWeb do
    pipe_through :api

    post "/user", UserController, :create_or_update
    get "/user/:user_code/referrals", UserController, :show_referrals
  end
end
