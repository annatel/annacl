defmodule Annacl do
  @moduledoc """
  Annacl
  """

  @behaviour Annacl.Behaviour

  alias Annacl.ACL
  alias Annacl.ACL.Roles.Role
  alias Annacl.ACL.Permissions.Permission
  alias Annacl.ACL.Performers.PerformerRole
  alias Annacl.ACL.Performers.PerformerPermission

  @spec create_permission(binary()) :: {:ok, Permission.t()} | {:error, Ecto.Changeset.t()}
  defdelegate create_permission(name), to: ACL, as: :create_permission

  @spec get_permission!(binary()) :: Permission.t()
  defdelegate get_permission!(name), to: ACL

  @spec assign_role_to_permission(Permission.t(), Role.t()) ::
          {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  defdelegate assign_role_to_permission(permission, role), to: ACL

  @spec remove_role_from_permission(Permission.t(), Role.t()) ::
          {:ok, any} | {:error, Ecto.Changeset.t()}
  defdelegate(remove_role_from_permission(permission, role), to: ACL)

  @spec create_role(binary()) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  defdelegate create_role(name), to: ACL

  @spec get_role!(binary()) :: Role.t()
  defdelegate get_role!(name), to: ACL

  @spec update_role(Role.t(), binary()) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  defdelegate update_role(role, name), to: ACL

  @spec grant_permission_to_role(Role.t(), Permission.t()) ::
          {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  defdelegate grant_permission_to_role(role, permission), to: ACL

  @spec revoke_permission_from_role(Role.t(), Permission.t()) ::
          {:ok, PermissionRole.t()} | {:error, Ecto.Changeset.t()}
  defdelegate revoke_permission_from_role(role, permission), to: ACL

  @spec role_can?(Role.t(), Permission.t()) :: boolean
  defdelegate role_can?(role, permission), to: ACL

  @spec assign_role!(%{performer_id: binary()}, binary()) ::
          {:ok, PerformerRole.t()} | {:error, Ecto.Changeset.t()}
  def assign_role!(%{performer_id: performer_id}, role_name) do
    role = ACL.get_role!(role_name)

    performer_id
    |> ACL.get_performer!()
    |> ACL.assign_role_to_performer(role)
  end

  @spec remove_role!(%{performer_id: binary()}, binary()) ::
          {:ok, PerformerRole.t()} | {:error, Ecto.Changeset.t()}
  def remove_role!(%{performer_id: performer_id}, role_name) do
    role = ACL.get_role!(role_name)

    performer_id
    |> ACL.get_performer!()
    |> ACL.remove_role_from_performer(role)
  end

  @spec grant_permission!(%{performer_id: binary()}, binary()) ::
          {:ok, PerformerPermission.t()} | {:error, Ecto.Changeset.t()}
  def grant_permission!(%{performer_id: performer_id}, permission_name) do
    permission = ACL.get_permission!(permission_name)

    performer_id
    |> ACL.get_performer!()
    |> ACL.grant_permission_to_performer(permission)
  end

  @spec revoke_permission!(%{performer_id: binary()}, binary()) ::
          {:ok, PerformerPermission.t()} | {:error, Ecto.Changeset.t()}
  def revoke_permission!(%{performer_id: performer_id}, permission_name) do
    permission = ACL.get_permission!(permission_name)

    performer_id
    |> ACL.get_performer!()
    |> ACL.revoke_permission_from_performer(permission)
  end

  @spec has_role?(%{performer_id: binary()}, binary) :: boolean
  def has_role?(%{performer_id: performer_id}, role_name) when is_binary(role_name) do
    role = ACL.get_role!(role_name)

    performer = ACL.get_performer!(performer_id)

    superadmin?(performer) || ACL.performer_has_role?(performer, role)
  end

  @spec can?(%{performer_id: binary()}, binary) :: boolean
  def can?(%{performer_id: performer_id}, permission_name)
      when is_binary(permission_name) do
    permission = ACL.get_permission!(permission_name)

    performer = ACL.get_performer!(performer_id)

    superadmin?(performer) || ACL.performer_can?(performer, permission)
  end

  @spec list_roles(%{performer_id: binary()}) :: [Role.t()]
  def list_roles(%{performer_id: performer_id}) do
    performer_id
    |> ACL.get_performer!()
    |> ACL.performer_list_roles()
  end

  @spec list_permissions(%{performer_id: binary()}) :: [Permission.t()]
  def list_permissions(%{performer_id: performer_id}) do
    performer_id
    |> ACL.get_performer!()
    |> ACL.performer_list_permissions()
  end

  defp superadmin?(%ACL.Performers.Performer{} = performer) do
    with %ACL.Roles.Role{} = superadmin_role <- ACL.get_role("superadmin") do
      ACL.performer_has_role?(performer, superadmin_role)
    else
      _ ->
        false
    end
  end
end
