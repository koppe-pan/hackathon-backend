# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :backend,
  ecto_repos: [Backend.Repo]

# Configures the endpoint
config :backend, BackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Xti3kov4H4ePDWvzFsX7BYT5/xDK+Tadx5MwlOvd1Yev/rPB2WKpO/TwTtJX7aAF",
  render_errors: [view: BackendWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Backend.PubSub,
  live_view: [signing_salt: "rseYVLOZ"]

# Configures swagger
config :backend, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      # phoenix routes will be converted to swagger paths
      router: BackendWeb.Router,
      # (optional) endpoint config used to set host, port and https schemes.
      endpoint: BackendWeb.Endpoint
    ]
  }

config :phoenix_swagger, json_library: Jason

# Configures guardian
config :backend, Backend.Guardian,
  issuer: "backend",
  secret_key: "FmN9JWv0UQH9mD6m2MuLOuWRaqll0uWBbsLnZpuPcQi88+YXvKHm+9r6QwW5HTag"

# Configure slack id and secret
config :backend, :slack_id, 1_019_130_625_447.1415318601443
config :backend, :slack_secret, "ef7b7da8fae519ce17ca7d6570fb23a4"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
