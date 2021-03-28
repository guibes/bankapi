defmodule Bankapi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Bankapi.Repo,
      # Start vault to Ecto Cloak
      Bankapi.Vault,
      # Start the Telemetry supervisor
      BankapiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bankapi.PubSub},
      # Start the Endpoint (http/https)
      BankapiWeb.Endpoint
      # Start a worker by calling: Bankapi.Worker.start_link(arg)
      # {Bankapi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bankapi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BankapiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
