defmodule L.MixProject do
  use Mix.Project

  def project do
    [
      app: :"little-giant",
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      releases: releases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {L.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:telemetry, "~> 1.2"},
      {:telemetry_poller, "~> 1.1"},
      {:telemetry_metrics, "~> 1.0"},
      {:s3, "~> 0.1.0"},
      {:benchee, "~> 1.3", only: :bench},
      {:finch, "~> 0.19.0"},
      {:phoenix, "~> 1.7.14"},
      {:bandit, "~> 1.5"}
    ]
  end

  defp releases do
    [
      "little-giant": [
        include_executables_for: [:unix]
      ]
    ]
  end
end
