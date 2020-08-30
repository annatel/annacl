defmodule Annacl.Behaviour.Performer do
  alias Annacl.Roles.Role
  alias Annacl.Permissions.Permission
  alias Annacl.Performers.PerformerRole
  alias Annacl.Performers.PerformerPermission

  @callback assign_role!(%{performer_id: integer()}, binary()) ::
              {:ok, PerformerRole.t()} | {:error, Ecto.Changeset.t()}
  @callback remove_role!(%{performer_id: integer()}, binary()) ::
              {:ok, PerformerRole.t()} | {:error, Ecto.Changeset.t()}
  @callback grant_permission!(%{performer_id: integer()}, binary()) ::
              {:ok, PerformerPermission.t()} | {:error, Ecto.Changeset.t()}
  @callback revoke_permission!(%{performer_id: integer()}, binary()) ::
              {:ok, PerformerPermission.t()} | {:error, Ecto.Changeset.t()}

  @callback has_role?(%{performer_id: integer()}, binary()) :: boolean
  @callback can?(%{performer_id: integer()}, binary()) :: boolean
  @callback list_roles(%{performer_id: integer()}) :: [Role.t()]
  @callback list_permissions(%{performer_id: integer()}) :: [Permission.t()]
end
