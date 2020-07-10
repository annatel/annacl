defmodule Annacl.Permissions do
  @moduledoc false

  import Ecto.Query, only: [where: 2]

  alias Annacl.Permissions.Permission
  alias Annacl.Roles.Role
  alias Annacl.PermissionsRoles

  @spec create_permission(map) ::
          {:ok, Annacl.Permissions.Permission.t()} | {:error, Ecto.Changeset.t()}
  def create_permission(attrs) when is_map(attrs) do
    %Permission{}
    |> Permission.changeset(attrs)
    |> repo().insert()
  end

  @spec get_permission!(binary) :: Permission.t()
  def get_permission!(name) when is_binary(name) do
    Permission
    |> where(name: ^name)
    |> repo().one!()
  end

  @spec assign_role(Permission.t(), Role.t()) ::
          {:ok, PermissionsRoles.PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  def assign_role(%Permission{} = permission, %Role{} = role) do
    PermissionsRoles.create_permission_role(permission, role)
  end

  @spec remove_role(Permission.t(), Role.t()) ::
          {:ok, PermissionsRoles.PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  def remove_role(%Permission{} = permission, %Role{} = role) do
    PermissionsRoles.delete_permission_role(permission, role)
  end

  defp repo() do
    Application.fetch_env!(:annacl, :repo)
  end
end
