defmodule Bmo.MixProject do
  use Mix.Project

  def project do
    [
      app: :bmo,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison, :timex],
      mod: {Bmo, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:coxir, git: "https://github.com/satom99/coxir.git"},
      {:coxir_commander, git: "https://github.com/satom99/coxir_commander.git"},
      {:porcelain, "~> 2.0"},
      {:timex, "~> 3.1"}
    ]
  end
end
