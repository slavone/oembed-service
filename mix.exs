defmodule OembedService.Mixfile do
  use Mix.Project

  def project do
    [
      app: :oembed_service,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :floki],
      mod: {OembedService.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.4"},
      {:oembed, git: "https://github.com/slavone/elixir-oembed", branch: "feature/support-third-party-providers"},
      {:poison, "~> 3.1"},
      {:distillery, "~> 1.4", runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
