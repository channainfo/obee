# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :obee,
  ecto_repos: [Obee.Repo]

# Configures the endpoint
config :obee, ObeeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NZY51jKig0tneIm07evRwwHNAL/wqlSVYHLUCJWkk2Eecp+Ke9N+bsxJNuwu753p",
  render_errors: [view: ObeeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Obee.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


# config :torch,
#   otp_app: :obee,
#   template_format: "eex"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
