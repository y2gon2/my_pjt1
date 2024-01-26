defmodule MyPjt1.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MyPjt1Web.Telemetry,
      MyPjt1.Repo,
      {DNSCluster, query: Application.get_env(:my_pjt1, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MyPjt1.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MyPjt1.Finch},
      # Start a worker by calling: MyPjt1.Worker.start_link(arg)
      # {MyPjt1.Worker, arg},
      # Start to serve requests, typically the last entry
      MyPjt1Web.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyPjt1.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MyPjt1Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
