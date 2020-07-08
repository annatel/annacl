defmodule Annacl.ACL do
  @moduledoc """
  ACL context
  """

  alias Annacl.ACL.Permissions
  alias Annacl.ACL.Roles
  alias Annacl.ACL.Performers

  defdelegate create_permission(attrs), to: Permissions
  defdelegate get_permission!(name), to: Permissions
  defdelegate assign_role_to_permission(permission, role), to: Permissions, as: :assign_role
  defdelegate remove_role_from_permission(permission, role), to: Permissions, as: :remove_role

  defdelegate create_role(attrs), to: Roles
  defdelegate get_role(name), to: Roles
  defdelegate get_role!(name), to: Roles
  defdelegate update_role(role, attrs), to: Roles
  defdelegate grant_permission_to_role(role, permission), to: Roles, as: :grant_permission
  defdelegate revoke_permission_from_role(role, permission), to: Roles, as: :revoke_permission
  defdelegate role_can?(role, permission), to: Roles, as: :can?

  defdelegate get_performer!(id), to: Performers
  defdelegate assign_role_to_performer(performer, role), to: Performers, as: :assign_role
  defdelegate remove_role_from_performer(performer, role), to: Performers, as: :remove_role

  defdelegate grant_permission_to_performer(performer, permission),
    to: Performers,
    as: :grant_permission

  defdelegate revoke_permission_from_performer(performer, role),
    to: Performers,
    as: :revoke_permission

  defdelegate performer_has_role?(performer, role), to: Performers, as: :has_role?

  defdelegate performer_can?(performer, permission),
    to: Performers,
    as: :can?

  defdelegate performer_list_roles(performer), to: Performers, as: :list_roles
  defdelegate performer_list_permissions(performer), to: Performers, as: :list_permissions
end
