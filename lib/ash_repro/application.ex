defmodule AshRepro.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AshReproWeb.Telemetry,
      AshRepro.Repo,
      {DNSCluster, query: Application.get_env(:ash_repro, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AshRepro.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AshRepro.Finch},
      # Start a worker by calling: AshRepro.Worker.start_link(arg)
      # {AshRepro.Worker, arg},
      # Start to serve requests, typically the last entry
      AshReproWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AshRepro.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AshReproWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
