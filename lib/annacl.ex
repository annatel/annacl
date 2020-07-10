defmodule Annacl do
  @moduledoc """
  Annacl
  """

  @behaviour Annacl.Behaviour.RoleAndPermission

  alias Annacl.Roles
  alias Annacl.Roles.Role
  alias Annacl.Permissions
  alias Annacl.Permissions.Permission
  alias Annacl.PermissionsRoles.PermissionRole
  alias Annacl.Performers
  alias Annacl.Performers.{Performer, PerformerRole, PerformerPermission}

  defmacro __using__(_opts) do
    quote do
      @behaviour Annacl.Behaviour.Performer

      unquote(__MODULE__)

      def assign_role!(%{performer_id: performer_id}, role_name),
        do: unquote(__MODULE__).assign_role!(%{performer_id: performer_id}, role_name)

      def remove_role!(%{performer_id: performer_id}, role_name),
        do: unquote(__MODULE__).remove_role!(%{performer_id: performer_id}, role_name)

      def grant_permission!(%{performer_id: performer_id}, permission_name),
        do: unquote(__MODULE__).grant_permission!(%{performer_id: performer_id}, permission_name)

      def revoke_permission!(%{performer_id: performer_id}, permission_name),
        do: unquote(__MODULE__).revoke_permission!(%{performer_id: performer_id}, permission_name)

      def has_role?(%{performer_id: performer_id}, role_name),
        do: unquote(__MODULE__).has_role?(%{performer_id: performer_id}, role_name)

      def can?(%{performer_id: performer_id}, permission_name),
        do: unquote(__MODULE__).can?(%{performer_id: performer_id}, permission_name)

      def list_roles(%{performer_id: performer_id}),
        do: unquote(__MODULE__).list_roles(%{performer_id: performer_id})

      def list_permissions(%{performer_id: performer_id}),
        do: unquote(__MODULE__).list_permissions(%{performer_id: performer_id})
    end
  end

  @spec create_permission(binary()) :: {:ok, Permission.t()} | {:error, Ecto.Changeset.t()}
  def create_permission(name) when is_binary(name) do
    Permissions.create_permission(%{name: name})
  end

  @spec get_permission!(binary()) :: Permission.t()
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

  @spec get_role!(binary()) :: Role.t()
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

  @spec create_performer :: {:ok, Performer.t()} | {:error, Ecto.Changeset.t()}
  defdelegate create_performer, to: Performers

  @spec assign_role!(%{performer_id: binary()}, binary()) ::
          {:ok, PerformerRole.t()} | {:error, Ecto.Changeset.t()}
  def assign_role!(%{performer_id: performer_id}, role_name) do
    role = get_role!(role_name)

    performer_id
    |> Performers.get_performer!()
    |> Performers.assign_role(role)
  end

  @spec remove_role!(%{performer_id: binary()}, binary()) ::
          {:ok, PerformerRole.t()} | {:error, Ecto.Changeset.t()}
  def remove_role!(%{performer_id: performer_id}, role_name) do
    role = get_role!(role_name)

    performer_id
    |> Performers.get_performer!()
    |> Performers.remove_role(role)
  end

  @spec grant_permission!(%{performer_id: binary()}, binary()) ::
          {:ok, PerformerPermission.t()} | {:error, Ecto.Changeset.t()}
  def grant_permission!(%{performer_id: performer_id}, permission_name) do
    permission = get_permission!(permission_name)

    performer_id
    |> Performers.get_performer!()
    |> Performers.grant_permission(permission)
  end

  @spec revoke_permission!(%{performer_id: binary()}, binary()) ::
          {:ok, PerformerPermission.t()} | {:error, Ecto.Changeset.t()}
  def revoke_permission!(%{performer_id: performer_id}, permission_name) do
    permission = get_permission!(permission_name)

    performer_id
    |> Performers.get_performer!()
    |> Performers.revoke_permission(permission)
  end

  @spec has_role?(%{performer_id: binary()}, binary) :: boolean
  def has_role?(%{performer_id: performer_id}, role_name) when is_binary(role_name) do
    role = get_role!(role_name)
    superadmin_role = Roles.get_role(superadmin_role_name())

    performer = Performers.get_performer!(performer_id)

    (not is_nil(superadmin_role) && Performers.has_role?(performer, superadmin_role)) ||
      Performers.has_role?(performer, role)
  end

  @spec can?(%{performer_id: binary()}, binary) :: boolean
  def can?(%{performer_id: performer_id}, permission_name) when is_binary(permission_name) do
    permission = get_permission!(permission_name)
    superadmin_role = Roles.get_role(superadmin_role_name())

    performer = Performers.get_performer!(performer_id)

    (not is_nil(superadmin_role) && Performers.has_role?(performer, superadmin_role)) ||
      Performers.can?(performer, permission)
  end

  @spec list_roles(%{performer_id: binary()}) :: [Role.t()]
  def list_roles(%{performer_id: performer_id}) do
    performer_id
    |> Performers.get_performer!()
    |> Performers.list_roles()
  end

  @spec list_permissions(%{performer_id: binary()}) :: [Permission.t()]
  def list_permissions(%{performer_id: performer_id}) do
    performer_id
    |> Performers.get_performer!()
    |> Performers.list_permissions()
  end

  defp superadmin_role_name() do
    Application.get_env(:annacl, :superadmin_role_name, "superadmin")
  end
end
