# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :peek_home,
  ecto_repos: [PeekHome.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :peek_home, PeekHomeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hN8G0lJN9gOoaHXp/pWqPjGRubSIGW+xq16axadVZDFHdPnyDIjsRxfcekjEH5Lf",
  render_errors: [view: PeekHomeWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: PeekHome.PubSub,
  live_view: [signing_salt: "kX7woYTW"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
