# Annacl

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/annatel/annacl/CI?cacheSeconds=3600&style=flat-square)](https://github.com/annatel/annacl/actions) [![GitHub issues](https://img.shields.io/github/issues-raw/annatel/annacl?style=flat-square&cacheSeconds=3600)](https://github.com/annatel/annacl/issues) [![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?cacheSeconds=3600?style=flat-square)](http://opensource.org/licenses/MIT) [![Hex.pm](https://img.shields.io/hexpm/v/annacl?style=flat-square)](https://hex.pm/packages/annacl) [![Hex.pm](https://img.shields.io/hexpm/dt/annacl?style=flat-square)](https://hex.pm/packages/annacl)

Associate models with permissions and roles.

This package allows you to manage user permissions and roles in a database.

## Installation

Annacl is published on [Hex](https://hex.pm/packages/annacl). The package can be installed by adding `annacl` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:annacl, "~> 2.0.0"}
  ]
end
```

After the packages are installed you must create a database migration to add the annacl tables to your database:

```elixir
defmodule MyApp.Repo.Migrations.AddAnnaclTables do
  use Ecto.Migration

  def up do
    Annacl.Migrations.V1.up()
  end

  def down do
    Annacl.Migrations.V1.down()
  end
end
```

This will run all of Annacl's versioned migrations for your database. Migrations between versions are idempotent and will never change after a release. As new versions are released you may need to run additional migrations.

Now, run the migration to create the table:

```sh
mix ecto.migrate
```

## Usage

```elixir
# config/config.exs
  config :annacl,
    repo: MyApp.Repo
    superadmin_role_name: "superadmin" # The name of the role that bypass all roles and permissions.
```

You have to add a integer fields named `performer_id` to the schema you want to add the permissions and roles.

```elixir
# lib/my_app/account/user.ex
defmodule MyApp.Account.User do
  use Ecto.Schema

  alias Annacl.Performers.Performer

  schema "users" do
    belongs_to(:performer, Performer)
  end

  def create_changeset(%__MODULE__{} = user, attrs) when is_map(attrs) do
    user
    |> cast(attrs, [])
    |> put_assoc(:performer, %{})
  end
end


# lib/my_app/account.ex
defmodule MyApp.Accounts
  use Annacl

  ...
end

# Don't forget to add the performer_id field in your user table via a migration

{:ok, _superadmin_role} = Annacl.create_role(Annacl.superadmin_role_name())

{:ok, _user_role} = Annacl.create_role("user")

{:ok, _} = Annacl.create_permission("posts.list")
{:ok, _} = Annacl.create_permission("posts.create")
{:ok, _} = Annacl.create_permission("posts.read")
{:ok, _} = Annacl.create_permission("post.udpate")

Annacl.grant_permission_to_role(user_role, ["posts.list", "posts.read"])

# How to assign role to users
user = %MyApp.Accounts.User{performer_id: 1}

MyApp.Accounts.assign_role!(user, Annacl.superadmin_role_name())

MyApp.Accounts.assign_role!(user, "user")

true = MyApp.Accounts.has_permission?(user, "posts.list")
true = MyApp.Accounts.has_permission?(user, "posts.read")
false = MyApp.Accounts.has_permission?(user, "posts.create")
false = MyApp.Accounts.has_permission?(user, "posts.update")

true = MyApp.Accounts.has_permission?(superadmin, "posts.list")
true = MyApp.Accounts.has_permission?(superadmin, "posts.create")
true = MyApp.Accounts.has_permission?(superadmin, "posts.read")
true = MyApp.Accounts.has_permission?(superadmin, "posts.update")
```

Read the entire documentation [here](https://hex.pm/packages/annacl)

## Test

Duplicate env/example.env to env/test.env and source it.

```sh
MIX_ENV=test mix do ecto.drop, ecto.create, ecto.migrate
mix test
```
