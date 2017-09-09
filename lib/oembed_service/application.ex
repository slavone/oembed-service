defmodule OembedService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias OembedService.Router
  alias OembedService.Providers.Registered

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Router, [], [port: 4000]),
      Registered.child_spec(System.get_env("OVERRIDE_LIST_OF_PROVIDERS"))
      # Starts a worker by calling: OembedService.Worker.start_link(arg)
      # {OembedService.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OembedService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
