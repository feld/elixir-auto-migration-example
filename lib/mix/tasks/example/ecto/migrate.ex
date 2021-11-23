defmodule Mix.Tasks.Example.Ecto.Migrate do
  use Mix.Task
  require Logger

  @shortdoc "Wrapper on `ecto.migrate` task."

  @aliases [
    n: :step,
    v: :to
  ]

  @switches [
    all: :boolean,
    step: :integer,
    to: :integer,
    quiet: :boolean,
    log_sql: :boolean,
    strict_version_order: :boolean,
    migrations_path: :string
  ]

  @moduledoc """
  Changes `Logger` level to `:info` before start migration.
  Changes level back when migration ends.

  ## Start migration

      mix example.ecto.migrate [OPTIONS]

  Options:
    - see https://hexdocs.pm/ecto/2.0.0/Mix.Tasks.Ecto.Migrate.html
  """

  @impl true
  def run(args \\ []) do
    Application.load(:example)
    {opts, _} = OptionParser.parse!(args, strict: @switches, aliases: @aliases)

    if Application.get_env(:example, Example.Repo)[:ssl] do
      Application.ensure_all_started(:ssl)
    end

    opts =
      if opts[:to] || opts[:step] || opts[:all],
        do: opts,
        else: Keyword.put(opts, :all, true)

    opts =
      if opts[:quiet],
        do: Keyword.merge(opts, log: false, log_sql: false),
        else: opts

    path = Ecto.Migrator.migrations_path(Example.Repo)

    level = Logger.level()
    Logger.configure(level: :info)

    {:ok, _, _} = Ecto.Migrator.with_repo(Example.Repo, &Ecto.Migrator.run(&1, path, :up, opts))

    Logger.configure(level: level)
  end
end
