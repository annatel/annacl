defmodule Annacl do
  @moduledoc """
  Annacl
  """

  @behaviour Annacl.Behaviour.RoleAndPermission

  alias Annacl.Roles
  alias Annacl.Roles.Role
  alias Annacl.Permissions
  alias Annacl.Permissions.Permission
  alias Annacl.Performers
  alias Annacl.Performers.Performer

  defmacro __using__(_opts) do
    quote do
      @behaviour Annacl.Behaviour.Performer

      unquote(__MODULE__)

      @spec assign_role!(%{performer_id: integer}, binary | [binary]) :: map
      def assign_role!(parent, roles_name),
        do: unquote(__MODULE__).assign_role!(parent, roles_name)

      @spec remove_role!(%{performer_id: integer}, binary | [binary]) :: map
      def remove_role!(parent, roles_name),
        do: unquote(__MODULE__).remove_role!(parent, roles_name)

      @spec grant_permission!(%{performer_id: integer}, binary | [binary]) :: map
      def grant_permission!(parent, permissions_name),
        do: unquote(__MODULE__).grant_permission!(parent, permissions_name)

      @spec revoke_permission!(%{performer_id: integer}, binary | [binary]) :: map
      def revoke_permission!(parent, permissions_name),
        do: unquote(__MODULE__).revoke_permission!(parent, permissions_name)

      @spec has_role?(%{performer_id: integer}, binary) :: boolean
      def has_role?(parent, role_name), do: unquote(__MODULE__).has_role?(parent, role_name)

      @spec has_permission?(%{performer_id: integer}, binary) :: boolean
      def has_permission?(parent, permission_name),
        do: unquote(__MODULE__).has_permission?(parent, permission_name)

      @spec list_roles(%{performer_id: integer}) :: [Role.t()]
      def list_roles(parent),
        do: unquote(__MODULE__).list_roles(parent)

      @spec list_permissions(%{performer_id: integer}) :: [Permission.t()]
      def list_permissions(parent), do: unquote(__MODULE__).list_permissions(parent)
    end
  end

  @spec create_permission(binary()) :: {:ok, Permission.t()} | {:error, Ecto.Changeset.t()}
  def create_permission(name) when is_binary(name) do
    Permissions.create_permission(%{name: name})
  end

  @spec get_permission!(binary()) :: Permission.t()
  defdelegate get_permission!(name), to: Permissions

  @spec update_permission(Permission.t(), binary()) ::
          {:ok, Permission.t()} | {:error, Ecto.Changeset.t()}
  def update_permission(%Permission{} = permission, name) when is_binary(name) do
    Permissions.update_permission(permission, %{name: name})
  end

  @spec create_role(binary()) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  def create_role(name) when is_binary(name) do
    Roles.create_role(%{name: name})
  end

  @spec get_role!(binary()) :: Role.t()
  defdelegate get_role!(name), to: Roles

  @spec update_role(Role.t(), binary()) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  def update_role(%Role{} = role, name) when is_binary(name) do
    Roles.update_role(role, %{name: name})
  end

  @spec grant_permission_to_role!(Role.t(), binary | [binary]) :: Role.t()
  def grant_permission_to_role!(%Role{} = role, permissions_name) do
    Roles.grant_permission!(role, permissions_name)
  end

  @spec revoke_permission_from_role!(Role.t(), binary | [binary]) :: Role.t()
  def revoke_permission_from_role!(%Role{} = role, permissions_name) do
    Roles.revoke_permission!(role, permissions_name)
  end

  @spec role_has_permission?(Role.t(), binary) :: boolean
  defdelegate role_has_permission?(role, permission_name), to: Roles, as: :has_permission?

  @spec create_performer :: {:ok, Performer.t()} | {:error, Ecto.Changeset.t()}
  defdelegate create_performer, to: Performers

  @spec assign_role!(%{performer_id: integer}, binary | [binary]) :: map
  def assign_role!(%{performer_id: performer_id} = parent, roles_name) do
    performer_id |> Performers.get_performer!() |> Performers.assign_role!(roles_name)

    parent
  end

  @spec remove_role!(%{performer_id: integer}, binary | [binary]) :: map
  def remove_role!(%{performer_id: performer_id} = parent, roles_name) do
    performer_id |> Performers.get_performer!() |> Performers.remove_role!(roles_name)

    parent
  end

  @spec grant_permission!(%{performer_id: integer}, binary | [binary]) :: map
  def grant_permission!(%{performer_id: performer_id} = parent, permissions_name) do
    performer_id |> Performers.get_performer!() |> Performers.grant_permission!(permissions_name)

    parent
  end

  @spec revoke_permission!(%{performer_id: integer}, binary | [binary]) :: map
  def revoke_permission!(%{performer_id: performer_id} = parent, permissions_name) do
    performer_id |> Performers.get_performer!() |> Performers.revoke_permission!(permissions_name)

    parent
  end

  @spec has_role?(%{performer_id: integer}, binary) :: boolean
  def has_role?(%{performer_id: performer_id}, role_name) when is_binary(role_name) do
    performer_id
    |> Performers.get_performer!()
    |> Performers.has_any_roles?([superadmin_role_name(), role_name])
  end

  @spec has_permission?(%{performer_id: integer}, binary) :: boolean
  def has_permission?(%{performer_id: performer_id}, permission_name)
      when is_binary(permission_name) do
    performer = Performers.get_performer!(performer_id)

    Performers.has_role?(performer, superadmin_role_name()) ||
      Performers.has_permission?(performer, permission_name)
  end

  @spec list_roles(%{performer_id: integer}) :: [Role.t()]
  def list_roles(%{performer_id: performer_id}) do
    performer_id
    |> Performers.get_performer!()
    |> Performers.list_roles()
  end

  @spec list_permissions(%{performer_id: integer}) :: [Permission.t()]
  def list_permissions(%{performer_id: performer_id}) do
    performer_id
    |> Performers.get_performer!()
    |> Performers.list_permissions()
  end

  @spec superadmin_role_name :: binary()
  def superadmin_role_name() do
    Application.get_env(:annacl, :superadmin_role_name, "superadmin")
  end

  @spec repo :: any
  def repo() do
    Application.fetch_env!(:annacl, :repo)
  end
end
