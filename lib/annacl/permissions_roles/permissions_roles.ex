defmodule Annacl.PermissionsRoles do
  @moduledoc false
  import Ecto.Query, only: [where: 2]

  alias Annacl.Permissions.Permission
  alias Annacl.Roles.Role
  alias Annacl.PermissionsRoles.PermissionRole

  @spec create_permission_role(Permission.t(), Role.t()) ::
          {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  def create_permission_role(%Permission{id: permission_id}, %Role{id: role_id})
      when is_binary(permission_id) and is_binary(role_id) do
    %PermissionRole{}
    |> PermissionRole.changeset(%{permission_id: permission_id, role_id: role_id})
    |> repo().insert()
  end

  @spec delete_permission_role(Permission.t(), Role.t()) ::
          {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  def delete_permission_role(%Permission{id: permission_id}, %Role{id: role_id})
      when is_binary(permission_id) and is_binary(role_id) do
    PermissionRole
    |> where(permission_id: ^permission_id, role_id: ^role_id)
    |> repo().one!()
    |> repo().delete()
  end

  defp repo() do
    Application.fetch_env!(:annacl, :repo)
  end
end
