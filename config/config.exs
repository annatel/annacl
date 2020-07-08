import Config

if(Mix.env() == :test) do
  config :logger, level: System.get_env("EX_LOG_LEVEL", "warn") |> String.to_atom()

  config :annacl, ecto_repos: [Annacl.TestRepo]

  config :annacl, Annacl.TestRepo,
    url: System.get_env("ANNACL__DATABASE_TEST_URL"),
    show_sensitive_data_on_connection_error: true,
    pool: Ecto.Adapters.SQL.Sandbox

  config :annacl,
    repo: Annacl.TestRepo
end
