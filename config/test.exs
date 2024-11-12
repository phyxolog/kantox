import Config

config :kantox, Kantox.Repo,
  database: "priv/kantox_test_#{System.get_env("MIX_TEST_PARTITION")}.db",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kantox, KantoxWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "37UMz7alDRvnO415Mimr1rhZS0YvPQOh0CMa2rEZomhbgvNYk83GSIOoa58/7rIz",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
