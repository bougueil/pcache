defmodule Pcache.MixProject do
  use Mix.Project

  def project do
    [
      app: :pcache,
      version: "0.1.0",
      elixir: "~> 1.18",
      package: package(),
      start_permanent: Mix.env() == :prod,
      description: "A cache for an elixir process.",
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
      {:ex_doc, "~> 0.38", only: :docs}
    ]
  end

  defp package do
    %{
      licenses: ["Apache-2.0"],
      maintainers: ["bougueil"],
      links: %{"GitHub" => "https://github.com/bougueil/pcache"}
    }
  end
end
