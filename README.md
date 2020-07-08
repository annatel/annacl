# Annacl

[![Actions Status](https://github.com/annatel/annacl/workflows/CI/badge.svg)](https://github.com/annatel/annacl/actions)

Associate models with permissions and roles.

This package allows you to manage user permissions and roles in a database.

## Installation

Annacl is published on [Hex](https://hex.pm/packages/annacl). The package can be installed by adding `annacl` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:annacl, "~> 0.1.0"}
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


# lib/my_app/account/user.ex
defmodule MyApp.Account.User do
  use Ecto.Schema

  alias Annacl.ACL.Performers.Performer

  schema "users" do
    belongs_to(:performer, Performer)
  end
end


# lib/my_app/account.ex
defmodule MyApp.Accounts
  import Annacl

  ...
end

# superadmin is a special role that bypass all roles and permissions
{:ok, _superadmin_role} = Annacl.create_role(%{name: "superadmin"})

{:ok, _user_role} = Annacl.create_role(%{name: "user"})

{:ok, posts_list} = Annacl.create_permission(%{name: "posts.list"})
{:ok, posts_create} = Annacl.create_permission(%{name: "posts.create"})
{:ok, posts_read} = Annacl.create_permission(%{name: "posts.read"})
{:ok, posts_update} = Annacl.create_permission(%{name: "post.udpate"})

Annacl.grant_permission_to_role(user_role, posts_list)
Annacl.grant_permission_to_role(user_role, posts_read)


superadmin = MyApp.Accounts.assign_role!(%MyApp.Accounts.User{performer_id: "00000000-0000-0000-0000-000000000000"}, "superadmin")

user = MyApp.Accounts.assign_role!(%MyApp.Accounts.User{performer_id: "00000000-0000-0000-0000-000000000001"}, "user")

true = MyApp.Accounts.can?(superadmin, "posts.list")
true = MyApp.Accounts.can?(superadmin, "posts.create")
true = MyApp.Accounts.can?(superadmin, "posts.read")
true = MyApp.Accounts.can?(superadmin, "posts.update")

true = MyApp.Accounts.can?(user, "posts.list")
false = MyApp.Accounts.can?(superadmin, "posts.create")
true = MyApp.Accounts.can?(superadmin, "posts.read")
false = MyApp.Accounts.can?(superadmin, "posts.update")
```

Read the entire documentation [here](https://hex.pm/packages/annacl)

## Test

Duplicate env/example.env to env/test.env and source it.

```sh
MIX_ENV=test mix do ecto.drop, ecto.create, ecto.migrate
mix test
```
