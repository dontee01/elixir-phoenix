defmodule Pms.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PmsWeb.Telemetry,
      Pms.Repo,
      {DNSCluster, query: Application.get_env(:pms, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Pms.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Pms.Finch},
      # Start a worker by calling: Pms.Worker.start_link(arg)
      # {Pms.Worker, arg},
      # Start to serve requests, typically the last entry
      PmsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pms.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PmsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
