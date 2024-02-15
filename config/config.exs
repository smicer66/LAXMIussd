# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ussd,
  ecto_repos: [Ussd.Repo]

config :endon,
  repo: Ussd.Repo

config :soap, :globals, version: ["1.1"]

# Configures the endpoint
config :ussd, UssdWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tPq9xUL2nK+SFRuwtmCDlBCAJK04EINyhS81Hr8M5GbDSZZzWiZZ4D0a6aAINPFi",
  render_errors: [view: UssdWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ussd.PubSub, adapter: Phoenix.PubSub.PG2],
  http: [port: 4000, protocol_options: [idle_timeout: 60_000]]

config :ussd, Ussd.Cron,
  jobs: [
    # # Every minute
    # {"* * * * *", {Ussd, :send, []}},
    # # Every 15 minutes
    # {"*/15 * * * *", fn -> System.cmd("rm", ["/tmp/tmp_"]) end},
    # # Runs on 18, 20, 22, 0, 2, 4, 6:
    # {"0 18-6/2 * * *", fn -> :mnesia.backup('/var/backup/mnesia') end},
    # # Runs every midnight:
    # {"@daily", {Backup, :backup, []}}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# config :nice_nickname, :bad_words,
#   "resources/profanity/profanity.json"

# config :nice_nickname, :prefix,
#   "resources/words/verbs.json"

# config :nice_nickname, :suffix,
#   "resources/words/nouns.json"
