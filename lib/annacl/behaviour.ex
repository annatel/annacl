defmodule Annacl.Behaviour do
  alias Annacl.ACL.Permissions.Permission
  alias Annacl.ACL.Roles.Role

  @callback create_permission(map) :: {:ok, Permission.t()} | {:error, Ecto.Changeset.t()}
  @callback get_permission!(binary) :: Permission.t()
  @callback assign_role_to_permission(Permission.t(), Role.t()) ::
              {:ok, any} | {:error, Ecto.Changeset.t()}
  @callback remove_role_from_permission(Permission.t(), Role.t()) ::
              {:ok, any} | {:error, Ecto.Changeset.t()}

  @callback create_role(map) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  @callback get_role!(binary) :: Role.t()
  @callback update_role(Role.t(), map) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  @callback grant_permission_to_role(Role.t(), Permission.t()) ::
              {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  @callback revoke_permission_from_role(Role.t(), Permission.t()) ::
              {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  @callback role_can?(Role.t(), Permission.t()) :: boolean

  @callback assign_role!(map(), binary()) :: {:ok, any} | {:error, Ecto.Changeset.t()}
  @callback remove_role!(map(), binary()) :: {:ok, any} | {:error, Ecto.Changeset.t()}
  @callback grant_permission!(map(), binary()) :: {:ok, any} | {:error, Ecto.Changeset.t()}
  @callback revoke_permission!(map(), binary()) :: {:ok, any} | {:error, Ecto.Changeset.t()}

  @callback has_role?(binary | map(), binary) :: boolean
  @callback can?(binary | map(), binary) :: boolean
end
