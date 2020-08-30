# Annacl

[![Actions Status](https://github.com/annatel/annacl/workflows/CI/badge.svg)](https://github.com/annatel/annacl/actions)

Associate models with permissions and roles.

This package allows you to manage user permissions and roles in a database.

## Installation

Annacl is published on [Hex](https://hex.pm/packages/annacl). The package can be installed by adding `annacl` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:annacl, "~> 0.5.0"}
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


# lib/my_app/account/user.ex
defmodule MyApp.Account.User do
  use Ecto.Schema

  alias Annacl.Performers.Performer

  schema "users" do
    belongs_to(:performer, Performer)
  end

  def create_changeset(%__MODULE__{} = user, attrs) when is_map(attrs) do
    attrs = attrs |> Map.put(:performer, %{})

    user
    |> cast(attrs, [])
    |> cast_assoc(:performer, required: true)
  end
end


# lib/my_app/account.ex
defmodule MyApp.Accounts
  use Annacl

  ...
end

# Don't forget to add the performer_id field in your user table via a migration

{:ok, _superadmin_role} = Annacl.create_role("superadmin")

{:ok, _user_role} = Annacl.create_role("user")

{:ok, posts_list} = Annacl.create_permission("posts.list")
{:ok, posts_create} = Annacl.create_permission("posts.create")
{:ok, posts_read} = Annacl.create_permission("posts.read")
{:ok, posts_update} = Annacl.create_permission("post.udpate")

Annacl.grant_permission_to_role(user_role, posts_list)
Annacl.grant_permission_to_role(user_role, posts_read)

# How to assign role to users
superadmin = MyApp.Accounts.assign_role!(%MyApp.Accounts.User{performer_id: 1}, "superadmin")

user = MyApp.Accounts.assign_role!(%MyApp.Accounts.User{performer_id: 2}, "user")

true = MyApp.Accounts.can?(user, "posts.list")
true = MyApp.Accounts.can?(user, "posts.read")
false = MyApp.Accounts.can?(user, "posts.create")
false = MyApp.Accounts.can?(user, "posts.update")

true = MyApp.Accounts.can?(superadmin, "posts.list")
true = MyApp.Accounts.can?(superadmin, "posts.create")
true = MyApp.Accounts.can?(superadmin, "posts.read")
true = MyApp.Accounts.can?(superadmin, "posts.update")
```

Read the entire documentation [here](https://hex.pm/packages/annacl)

## Test

Duplicate env/example.env to env/test.env and source it.

```sh
MIX_ENV=test mix do ecto.drop, ecto.create, ecto.migrate
mix test
```

## Upgrate from 0.5.0 to 1.0.0

I removed the use of binary_id and due to a lack of time, did not provide an upgrade path. 
If you want to upgrade you will need to re-create your roles and permissions and re-assign a performer to your model.
MR for the upgrade path will be gratefully accepted.
