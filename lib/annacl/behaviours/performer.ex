defmodule Annacl.Behaviour.Performer do
  alias Annacl.Roles.Role
  alias Annacl.Permissions.Permission

  @callback assign_role!(Annacl.performer_container(), binary | [binary]) ::
              Annacl.performer_container()
  @callback remove_role!(Annacl.performer_container(), binary | [binary]) ::
              Annacl.performer_container()

  @callback grant_permission!(Annacl.performer_container(), binary | [binary]) ::
              Annacl.performer_container()
  @callback revoke_permission!(Annacl.performer_container(), binary | [binary]) ::
              Annacl.performer_container()

  @callback has_role?(Annacl.performer_container(), binary) :: boolean
  @callback has_permission?(Annacl.performer_container(), binary) :: boolean

  @callback list_roles(Annacl.performer_container()) :: [Role.t()]
  @callback list_permissions(Annacl.performer_container()) :: [Permission.t()]
end
