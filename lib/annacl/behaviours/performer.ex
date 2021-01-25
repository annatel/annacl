defmodule Annacl.Behaviour.Performer do
  alias Annacl.Roles.Role
  alias Annacl.Permissions.Permission

  @callback assign_role!(%{performer_id: integer}, binary | [binary]) :: Performer.t()
  @callback remove_role!(%{performer_id: integer}, binary | [binary]) :: Performer.t()

  @callback grant_permission!(%{performer_id: integer}, binary | [binary]) :: Performer.t()
  @callback revoke_permission!(%{performer_id: integer}, binary | [binary]) :: Performer.t()

  @callback has_role?(%{performer_id: integer}, binary) :: boolean
  @callback has_permission?(%{performer_id: integer}, binary) :: boolean

  @callback list_roles(%{performer_id: integer}) :: [Role.t()]
  @callback list_permissions(%{performer_id: integer}) :: [Permission.t()]
end
