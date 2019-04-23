defmodule Obee.MixProject do
  use Mix.Project

  def project do
    [
      app: :obee,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Obee.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.2"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:arc, "~> 0.11.0" },
      # If using Amazon S3:
      {:ex_aws, "~> 2.0"},
      {:ex_aws_s3, "~> 2.0"},
      {:hackney, "~> 1.6"},
      {:poison, "~> 3.1"},
      {:sweet_xml, "~> 0.6"},

      # Password hashing
      {:comeonin, "~> 4.1"},
      {:pbkdf2_elixir, "~> 0.12"},

      # {:torch, "~> 2.0.0-rc.1"},
      # {:phoenix_oauth2_provider, "~> 0.4.1"},

      {:absinthe, "~> 1.4.0"},
      {:absinthe_plug, "~> 1.4"},    # the GraphQL toolkit for Elixir
      {:absinthe_ecto, "~> 0.1.3"},  # Provides some helper functions for easy batching of Ecto assocations
      {:absinthe_phoenix, "~> 1.4"}, # Absinthe subscriptions with Phoenix

      {:dataloader, "~> 1.0.0"},
      {:scrivener_ecto, "~> 2.0"}, # paginate for paging

    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
