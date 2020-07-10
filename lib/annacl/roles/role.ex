defmodule Annacl.Roles.Role do
  @moduledoc """
  Ecto Schema that represent a role.
  """
  use Annacl.Schema

  alias Annacl.Permissions.Permission
  alias Annacl.PermissionsRoles.PermissionRole

  schema "annacl_roles" do
    field(:name, :string)

    many_to_many(:permissions, Permission, join_through: PermissionRole)

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
