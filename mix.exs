defmodule Lsystem.Mixfile do
  use Mix.Project

  def project do
    [app: :pythagoras_tree,
     version: "0.0.1",
     elixir: "~> 1.0.0",
     deps: deps
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:workex, "~> 0.7.0"}
    ]
  end
end
