defmodule Prefab.Mixfile do
  use Mix.Project

  def project do
    [
      app: :prefab,
      version: "0.1.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # [mod: {Prefab.App, []}, applications: [:logger, :grpc, :poison]]
    [
      extra_applications: [:logger, :grpc, :poison]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      # {:grpc, path: "../../"},
      {:grpc, github: "tony612/grpc-elixir"},
      {:poison, "~> 3.0"},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false}
    ]
  end
end

