defmodule App.MixProject do
  use Mix.Project

  def project do
    [
      app: :app,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
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
      {:mint, "~> 1.6"},
      {:plug_cowboy, "~> 2.7"}
    ]
  end
end
