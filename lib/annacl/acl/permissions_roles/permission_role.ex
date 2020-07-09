defmodule Annacl.ACL.PermissionsRoles.PermissionRole do
  @moduledoc """
  Ecto Schema that represent the association between a permission and a role.
  """
  use Annacl.Schema

  alias Annacl.ACL.Permissions.Permission
  alias Annacl.ACL.Roles.Role

  schema "annacl_permission_annacl_role" do
    belongs_to(:permission, Permission)
    belongs_to(:role, Role)

    timestamps()
  end

  @spec changeset(PermissionRole.t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = permission_role, attrs) when is_map(attrs) do
    permission_role
    |> cast(attrs, [:permission_id, :role_id])
    |> validate_required([:permission_id, :role_id])
    |> assoc_constraint(:permission)
    |> assoc_constraint(:role)
    |> unique_constraint(:permission_role, name: :permission_role_permission_id_role_id_index)
  end
end
