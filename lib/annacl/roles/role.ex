defmodule Annacl.Roles.Role do
  @moduledoc """
  Ecto Schema that represent a role.
  """
  use Ecto.Schema

  import Ecto.Changeset,
    only: [cast: 3, validate_required: 2, unique_constraint: 2]

  alias Annacl.Permissions.Permission
  alias Annacl.PermissionsRoles.PermissionRole

  @type t :: %__MODULE__{
          id: integer,
          inserted_at: DateTime.t(),
          name: binary,
          permissions: [Permission.t()],
          updated_at: DateTime.t()
        }

  schema "annacl_roles" do
    field(:name, :string)

    many_to_many(:permissions, Permission,
      join_through: PermissionRole,
      on_replace: :delete,
      unique: true
    )

    timestamps()
  end

  @spec changeset(Role.t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = role, attrs) when is_map(attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
