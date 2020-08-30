defmodule Annacl.Performers do
  @moduledoc false

  import Ecto.Query, only: [where: 2, preload: 2]
  alias Ecto.Multi

  alias Annacl.Performers.{Performer, PerformerPermission, PerformerRole}
  alias Annacl.Permissions.Permission
  alias Annacl.Roles.Role

  @spec get_performer!(integer()) :: Performer.t()
  def get_performer!(id) when is_integer(id) do
    Performer
    |> preload([[roles: :permissions], :permissions])
    |> repo().get!(id)
  end

  @spec create_performer() :: {:ok, Performer.t()} | {:error, Ecto.Changeset.t()}
  def create_performer() do
    %Performer{}
    |> Ecto.Changeset.change(%{})
    |> repo().insert()
  end

  @spec assign_role(Performer.t(), Role.t() | [Role.t()]) ::
          {:ok, PerformerRole.t() | [PerformerRole.t()]} | {:error, Ecto.Changeset.t()}
  def assign_role(%Performer{} = performer, %Role{} = role) do
    with {:ok, [performer_role]} <- assign_role(performer, [role]) do
      {:ok, performer_role}
    else
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def assign_role(%Performer{} = performer, roles) when is_list(roles) do
    roles
    |> Enum.reduce(Multi.new(), fn role, acc ->
      performer_role =
        %PerformerRole{}
        |> PerformerRole.changeset(%{performer_id: performer.id, role_id: role.id})

      acc
      |> Multi.insert(:"role_#{role.id}", performer_role)
    end)
    |> repo().transaction()
    |> case do
      {:ok, performer_roles} ->
        {:ok, Map.values(performer_roles)}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  @spec remove_role(Performer.t(), Role.t()) ::
          {:ok, PerformerRole.t()} | {:error, Ecto.Changeset.t()}
  def remove_role(%Performer{id: performer_id}, %Role{id: role_id}) do
    PerformerRole
    |> where(performer_id: ^performer_id, role_id: ^role_id)
    |> repo().one!()
    |> repo().delete()
  end

  @spec grant_permission(Performer.t(), Permission.t() | list) ::
          {:ok, PerformerPermission.t() | [PerformerPermission.t()]}
          | {:error, Ecto.Changeset.t()}
  def grant_permission(%Performer{} = performer, %Permission{} = permission) do
    with {:ok, [performer_permission]} <- grant_permission(performer, [permission]) do
      {:ok, performer_permission}
    else
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def grant_permission(%Performer{} = performer, permissions) when is_list(permissions) do
    permissions
    |> Enum.reduce(Multi.new(), fn permission, acc ->
      performer_permission =
        %PerformerPermission{}
        |> PerformerPermission.changeset(%{
          performer_id: performer.id,
          permission_id: permission.id
        })

      acc
      |> Multi.insert(:"permission_#{permission.id}", performer_permission)
    end)
    |> repo().transaction()
    |> case do
      {:ok, performer_permissions} ->
        {:ok, Map.values(performer_permissions)}

      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  @spec revoke_permission(Performer.t(), Permission.t()) ::
          {:ok, PerformerPermission.t()} | {:error, Ecto.Changeset.t()}
  def revoke_permission(%Performer{id: performer_id}, %Permission{id: permission_id}) do
    PerformerPermission
    |> where(performer_id: ^performer_id, permission_id: ^permission_id)
    |> repo().one!()
    |> repo().delete()
  end

  @spec has_role?(Performer.t(), Role.t() | [Role.t()]) :: boolean
  def has_role?(%Performer{} = performer, %Role{} = role) do
    has_role?(performer, [role])
  end

  def has_role?(%Performer{} = performer, roles) when is_list(roles) do
    performer_role_ids = list_roles(performer) |> Enum.map(& &1.id)

    roles
    |> Enum.any?(fn role ->
      performer_role_ids |> Enum.any?(&(&1 == role.id))
    end)
  end

  @spec can?(Performer.t(), Permission.t() | [Permission.t()]) :: boolean
  def can?(%Performer{} = performer, %Permission{} = permission) do
    can?(performer, [permission])
  end

  def can?(%Performer{} = performer, permissions) when is_list(permissions) do
    performer_permission_ids = list_permissions(performer) |> Enum.map(& &1.id)

    permissions
    |> Enum.any?(fn permission ->
      performer_permission_ids |> Enum.any?(&(&1 == permission.id))
    end)
  end

  @spec list_roles(Performer.t()) :: [Role.t()]
  def list_roles(%Performer{} = performer) do
    performer = performer |> repo().preload(roles: [:permissions])

    performer.roles
  end

  @spec list_permissions(Performer.t()) :: [Permission.t()]
  def list_permissions(%Performer{} = performer) do
    performer = performer |> repo().preload([:permissions, roles: [:permissions]])

    performer.roles
    |> Enum.reduce([], fn roles, acc ->
      roles.permissions
      |> Enum.reduce(acc, fn permission, acc ->
        [permission | acc]
      end)
    end)
    |> Enum.concat(performer.permissions)
  end

  defp repo() do
    Application.fetch_env!(:annacl, :repo)
  end
end
