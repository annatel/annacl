defmodule Annacl.Performers do
  @moduledoc false

  import Ecto.Query, only: [preload: 2]

  alias Annacl.Performers.Performer
  alias Annacl.Roles
  alias Annacl.Roles.Role
  alias Annacl.Permissions
  alias Annacl.Permissions.Permission

  @spec create_performer() :: {:ok, Performer.t()} | {:error, Ecto.Changeset.t()}
  def create_performer() do
    %Performer{}
    |> Ecto.Changeset.change()
    |> Annacl.repo().insert()
  end

  @spec get_performer!(integer()) :: Performer.t()
  def get_performer!(id) when is_integer(id) do
    Performer
    |> preload([[roles: :permissions], :permissions])
    |> Annacl.repo().get!(id)
  end

  @spec assign_role!(Performer.t(), binary | [binary]) :: Performer.t()
  def assign_role!(%Performer{} = performer, roles_names) do
    performer = performer |> preload_roles()

    roles = roles_names |> List.wrap() |> Enum.map(&get_or_build_role(&1))

    roles =
      performer
      |> list_roles()
      |> Enum.concat(roles)
      |> Enum.uniq_by(& &1.name)

    performer
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:roles, roles)
    |> Annacl.repo().update!()
  end

  @spec remove_role!(Performer.t(), binary | [binary]) :: Performer.t()
  def remove_role!(%Performer{} = performer, roles_names) do
    performer = performer |> preload_roles()

    roles_names = roles_names |> List.wrap()

    roles =
      performer
      |> list_roles()
      |> Enum.reject(&(&1.name in roles_names))

    performer
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:roles, roles)
    |> Annacl.repo().update!()
  end

  @spec grant_permission!(Performer.t(), binary | [binary]) :: Performer.t()
  def grant_permission!(%Performer{} = performer, permissions_names) do
    performer = performer |> preload_roles() |> preload_permissions()

    permissions = permissions_names |> List.wrap() |> Enum.map(&get_or_build_permission(&1))

    permissions =
      performer
      |> list_permissions()
      |> Enum.concat(permissions)
      |> Enum.uniq_by(& &1.name)

    performer
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:permissions, permissions)
    |> Annacl.repo().update!()
  end

  @spec revoke_permission!(Performer.t(), binary | [binary]) :: Performer.t()
  def revoke_permission!(%Performer{} = performer, permissions_names) do
    performer = performer |> preload_permissions()

    permissions_names = permissions_names |> List.wrap()

    permissions =
      performer.permissions
      |> Enum.reject(&(&1.name in permissions_names))

    performer
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:permissions, permissions)
    |> Annacl.repo().update!()
  end

  @spec has_role?(Performer.t(), binary) :: boolean
  def has_role?(%Performer{} = performer, role_name) when is_binary(role_name) do
    performer
    |> preload_roles()
    |> list_roles()
    |> Enum.any?(&(&1.name == role_name))
  end

  @spec has_any_roles?(Performer.t(), [binary]) :: boolean
  def has_any_roles?(%Performer{} = performer, roles_names) when is_list(roles_names) do
    roles_names
    |> Enum.any?(&has_role?(performer, &1))
  end

  @spec has_permission?(Performer.t(), binary) :: boolean
  def has_permission?(%Performer{} = performer, permission_name)
      when is_binary(permission_name) do
    performer
    |> preload_roles()
    |> preload_permissions()
    |> list_permissions()
    |> Enum.any?(&(&1.name == permission_name))
  end

  @spec has_any_permissions?(Performer.t(), [binary]) :: boolean
  def has_any_permissions?(%Performer{} = performer, permissions_names)
      when is_list(permissions_names) do
    permissions_names
    |> Enum.any?(&has_permission?(performer, &1))
  end

  @spec list_roles(Performer.t()) :: [Role.t()]
  def list_roles(%Performer{roles: roles}), do: roles

  @spec list_permissions(Performer.t()) :: [Permission.t()]
  def list_permissions(%Performer{permissions: permissions, roles: roles}) do
    roles
    |> Enum.reduce([], fn roles, acc ->
      roles.permissions
      |> Enum.reduce(acc, fn permission, acc ->
        [permission | acc]
      end)
    end)
    |> Enum.concat(permissions)
  end

  @spec preload_roles(Performer.t()) :: Performer.t()
  defp preload_roles(%Performer{} = performer) do
    performer |> Annacl.repo().preload(roles: [:permissions])
  end

  defp preload_permissions(%Performer{} = performer) do
    performer |> Annacl.repo().preload([:permissions, roles: [:permissions]])
  end

  defp get_or_build_role(name) when is_binary(name) do
    Roles.get_role(name)
    |> case do
      %Role{} = role -> role
      nil -> %{name: name}
    end
  end

  defp get_or_build_permission(name) when is_binary(name) do
    Permissions.get_permission(name)
    |> case do
      %Permission{} = permission -> permission
      nil -> %{name: name}
    end
  end
end
