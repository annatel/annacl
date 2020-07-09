defmodule Annacl.ACL do
  @moduledoc false

  alias Annacl.ACL.Permissions
  alias Annacl.ACL.Roles
  alias PermissionRole
  alias Annacl.ACL.Performers

  @spec create_permission(binary()) :: {:ok, Permission.t()} | {:error, Ecto.Changeset.t()}
  def create_permission(name) when is_binary(name) do
    Permissions.create_permission(%{name: name})
  end

  @spec get_permission!(binary) :: Permission.t()
  defdelegate get_permission!(name), to: Permissions

  @spec assign_role_to_permission(Permission.t(), Role.t()) ::
          {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  defdelegate assign_role_to_permission(permission, role), to: Permissions, as: :assign_role

  @spec remove_role_from_permission(Permission.t(), Role.t()) ::
          {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  defdelegate remove_role_from_permission(permission, role), to: Permissions, as: :remove_role

  @spec create_role(binary()) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  def create_role(name) when is_binary(name) do
    Roles.create_role(%{name: name})
  end

  @spec get_role(binary) :: Role.t()
  defdelegate get_role(name), to: Roles

  @spec get_role!(binary) :: Role.t()
  defdelegate get_role!(name), to: Roles

  @spec update_role(Role.t(), binary()) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  def update_role(role, name) when is_binary(name) do
    Roles.update_role(role, %{name: name})
  end

  @spec grant_permission_to_role(Role.t(), Permission.t()) ::
          {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  defdelegate grant_permission_to_role(role, permission), to: Roles, as: :grant_permission

  @spec revoke_permission_from_role(Role.t(), Permission.t()) ::
          {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  defdelegate revoke_permission_from_role(role, permission), to: Roles, as: :revoke_permission

  @spec role_can?(Role.t(), Permission.t()) :: boolean
  defdelegate role_can?(role, permission), to: Roles, as: :can?

  @spec get_performer!(binary) :: Performer.t()
  defdelegate get_performer!(id), to: Performers

  @spec assign_role_to_performer(Performer.t(), [Role.t()] | Role.t()) ::
          {:ok, [PerformerRole.t()] | PerformerRole.t()} | {:error, Ecto.Changeset.t()}
  defdelegate assign_role_to_performer(performer, role), to: Performers, as: :assign_role

  @spec remove_role_from_performer(Performer.t(), Role.t()) ::
          {:error, Ecto.Changeset.t()} | {:ok, PerformerRole.t()}
  defdelegate remove_role_from_performer(performer, role), to: Performers, as: :remove_role

  @spec grant_permission_to_performer(Performer.t(), [Permission.t()] | Permission.t()) ::
          {:ok, [PerformerPermission.t()] | PerformerPermission.t()}
          | {:error, Ecto.Changeset.t()}
  defdelegate grant_permission_to_performer(performer, permission),
    to: Performers,
    as: :grant_permission

  @spec revoke_permission_from_performer(Performer.t(), Permission.t()) ::
          {:ok, PerformerPermission.t()} | {:error, Ecto.Changeset.t()}
  defdelegate revoke_permission_from_performer(performer, role),
    to: Performers,
    as: :revoke_permission

  @spec performer_has_role?(Performer.t(), [Role.t()] | Role.t()) :: boolean
  defdelegate performer_has_role?(performer, role), to: Performers, as: :has_role?

  @spec performer_can?(Performer.t(), [Permission.t()] | Permission.t()) :: boolean
  defdelegate performer_can?(performer, permission),
    to: Performers,
    as: :can?

  @spec performer_list_roles(Performer.t()) :: [Role.t()]
  defdelegate performer_list_roles(performer), to: Performers, as: :list_roles

  @spec performer_list_permissions(Performer.t()) :: [Permission.t()]
  defdelegate performer_list_permissions(performer), to: Performers, as: :list_permissions
end
