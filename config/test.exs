import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ash_repro, AshReproWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "QA17hxqqKQajrw8ypbiSBQCG6z5wPOQl/+2+d++bWxncNAC9+t/3dcavvy3YGEjh",
  server: false

# In test we don't send emails.
config :ash_repro, AshRepro.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :ash, :disable_async?, true
config :ash, :missed_notifications, :ignore
