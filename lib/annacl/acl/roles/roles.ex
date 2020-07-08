defmodule Annacl.ACL.Roles do
  @moduledoc """
  Roles context
  """
  import Ecto.Query, only: [where: 2, preload: 2]

  alias Annacl.ACL.Roles.Role
  alias Annacl.ACL.Permissions.Permission
  alias Annacl.ACL.PermissionsRoles
  alias Annacl.ACL.PermissionsRoles.PermissionRole

  @spec create_role(map) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  def create_role(attrs) when is_map(attrs) do
    %Role{}
    |> Role.changeset(attrs)
    |> repo().insert()
  end

  @spec get_role(binary) :: Role.t()
  def get_role(name) when is_binary(name) do
    Role
    |> where(name: ^name)
    |> preload(:permissions)
    |> repo().one()
  end

  @spec get_role!(binary) :: Role.t()
  def get_role!(name) when is_binary(name) do
    Role
    |> where(name: ^name)
    |> preload(:permissions)
    |> repo().one!()
  end

  @spec update_role(Role.t(), map) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  def update_role(%Role{} = role, attrs) when is_map(attrs) do
    role
    |> Role.changeset(attrs)
    |> repo().update()
  end

  @spec grant_permission(Role.t(), Permission.t()) ::
          {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  def grant_permission(%Role{} = role, %Permission{} = permission) do
    PermissionsRoles.create_permission_role(permission, role)
  end

  @spec revoke_permission(Role.t(), Permission.t()) ::
          {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  def revoke_permission(%Role{} = role, %Permission{} = permission) do
    PermissionsRoles.delete_permission_role(permission, role)
  end

  @spec can?(Role.t(), Permission.t()) :: boolean
  def can?(%Role{permissions: permissions}, %Permission{} = permission)
      when is_list(permissions) do
    permissions
    |> Enum.map(& &1.id)
    |> Enum.member?(permission.id)
  end

  defp repo() do
    Application.fetch_env!(:annacl, :repo)
  end
end
