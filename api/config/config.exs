# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :api,
  ecto_repos: [Api.Repo]

# Configures the endpoint
config :api, ApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nmFG2pwwEYv2Z1GsRIN6N/Oe5va2QdUC+FBNmQc8Z/5+BH1SiGLCS4kw9Ddqk+eh",
  render_errors: [view: ApiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Api.PubSub,
  live_view: [signing_salt: "2wWMXVz/"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :cors_plug,
  origin: ["*"],
  max_age: 86400,
  methods: ["GET", "POST", "PUT", "DELETE"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
