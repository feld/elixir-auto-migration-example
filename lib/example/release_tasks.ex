defmodule Example.ReleaseTasks do
  @repo Example.Repo

  def run(args) do
    [task | args] = String.split(args)

    case task do
      "migrate" -> migrate(args)
      "create" -> create()
    end
  end

  def migrate(args) do
    Mix.Tasks.Example.Ecto.Migrate.run(args)
  end

  def create do
    Application.load(:example)

    case @repo.__adapter__.storage_up(@repo.config) do
      :ok ->
        IO.puts("The database for #{inspect(@repo)} has been created")

      {:error, :already_up} ->
        IO.puts("The database for #{inspect(@repo)} has already been created")

      {:error, term} when is_binary(term) ->
        IO.puts(:stderr, "The database for #{inspect(@repo)} couldn't be created: #{term}")

      {:error, term} ->
        IO.puts(
          :stderr,
          "The database for #{inspect(@repo)} couldn't be created: #{inspect(term)}"
        )
    end
  end
end
