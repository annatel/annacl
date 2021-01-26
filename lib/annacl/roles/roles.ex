defmodule Annacl.Roles do
  @moduledoc false

  import Ecto.Query, only: [where: 2, preload: 2]

  alias Annacl.Roles.Role
  alias Annacl.Permissions
  alias Annacl.Permissions.Permission

  @spec create_role(map) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  def create_role(attrs) when is_map(attrs) do
    %Role{}
    |> Role.changeset(attrs)
    |> Annacl.repo().insert()
  end

  @spec get_role(binary) :: Role.t() | nil
  def get_role(name) when is_binary(name) do
    Role
    |> where(name: ^name)
    |> preload(:permissions)
    |> Annacl.repo().one()
  end

  @spec get_role!(binary) :: Role.t()
  def get_role!(name) when is_binary(name) do
    Role
    |> where(name: ^name)
    |> preload(:permissions)
    |> Annacl.repo().one!()
  end

  @spec update_role(Role.t(), map) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  def update_role(%Role{} = role, attrs) when is_map(attrs) do
    role
    |> Role.changeset(attrs)
    |> Annacl.repo().update()
  end

  @spec grant_permission!(Role.t(), binary | [binary]) :: Role.t()
  def grant_permission!(%Role{} = role, permissions_name) do
    role = role |> Annacl.repo().preload(:permissions, force: true)

    permissions = permissions_name |> List.wrap() |> Enum.map(&get_or_build_permission(&1))

    permissions =
      role.permissions
      |> Enum.concat(permissions)
      |> Enum.uniq_by(& &1.name)

    role
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:permissions, permissions)
    |> Annacl.repo().update!()
  end

  @spec revoke_permission!(Role.t(), binary | [binary]) :: Role.t()
  def revoke_permission!(%Role{} = role, permissions_name) do
    permissions_name = permissions_name |> List.wrap()

    role = role |> Annacl.repo().preload(:permissions, force: true)

    permissions =
      role.permissions
      |> Enum.reject(&(&1.name in permissions_name))

    role
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:permissions, permissions)
    |> Annacl.repo().update!()
  end

  @spec has_permission?(Role.t(), binary) :: boolean
  def has_permission?(%Role{} = role, permission_name) when is_binary(permission_name) do
    role
    |> list_permissions()
    |> Enum.map(& &1.name)
    |> Enum.member?(permission_name)
  end

  defp list_permissions(%Role{} = role) do
    %{permissions: permissions} = role |> Annacl.repo().preload(:permissions)

    permissions
  end

  defp get_or_build_permission(name) when is_binary(name) do
    Permissions.get_permission(name)
    |> case do
      nil -> %{name: name}
      %Permission{} = permission -> permission
    end
  end
end
