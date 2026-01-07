defmodule ExampleApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :example_app,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ExampleApp.Application, []}
    ]
  end

  defp deps do
    [
      # Use Git dependency until Hex package is published
      {:zauberflote, git: "https://github.com/miguelemosreverte/zauberflote.git", sparse: "backend"}
    ]
  end
end
