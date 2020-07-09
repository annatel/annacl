defmodule Annacl.Behaviour do
  alias Annacl.ACL.Roles.Role
  alias Annacl.ACL.Permissions.Permission
  alias Annacl.ACL.Performers.PerformerRole
  alias Annacl.ACL.Performers.PerformerPermission

  @callback create_permission(binary()) :: {:ok, Permission.t()} | {:error, Ecto.Changeset.t()}
  @callback get_permission!(binary()) :: Permission.t()
  @callback assign_role_to_permission(Permission.t(), Role.t()) ::
              {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  @callback remove_role_from_permission(Permission.t(), Role.t()) ::
              {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}

  @callback create_role(binary()) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  @callback get_role!(binary()) :: Role.t()
  @callback update_role(Role.t(), binary()) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  @callback grant_permission_to_role(Role.t(), Permission.t()) ::
              {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  @callback revoke_permission_from_role(Role.t(), Permission.t()) ::
              {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  @callback role_can?(Role.t(), Permission.t()) :: boolean

  @callback assign_role!(%{performer_id: binary()}, binary()) ::
              {:ok, PerformerRole.t()} | {:error, Ecto.Changeset.t()}
  @callback remove_role!(%{performer_id: binary()}, binary()) ::
              {:ok, PerformerRole.t()} | {:error, Ecto.Changeset.t()}
  @callback grant_permission!(%{performer_id: binary()}, binary()) ::
              {:ok, PerformerPermission.t()} | {:error, Ecto.Changeset.t()}
  @callback revoke_permission!(%{performer_id: binary()}, binary()) ::
              {:ok, PerformerPermission.t()} | {:error, Ecto.Changeset.t()}

  @callback has_role?(%{performer_id: binary()}, binary()) :: boolean
  @callback can?(%{performer_id: binary()}, binary()) :: boolean
end
