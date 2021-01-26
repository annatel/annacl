defmodule Annacl.Behaviour.RoleAndPermission do
  alias Annacl.Roles.Role
  alias Annacl.Permissions.Permission
  alias Annacl.Performers.Performer

  @callback create_permission(binary) :: {:ok, Permission.t()} | {:error, Ecto.Changeset.t()}
  @callback get_permission!(binary) :: Permission.t()
  @callback update_permission(Permission.t(), binary) ::
              {:ok, Permission.t()} | {:error, Ecto.Changeset.t()}

  @callback create_role(binary) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  @callback get_role!(binary) :: Role.t()
  @callback update_role(Role.t(), binary) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}

  @callback grant_permission_to_role!(Role.t(), binary | [binary]) :: Role.t()
  @callback revoke_permission_from_role!(Role.t(), binary | [binary]) :: Role.t()
  @callback role_has_permission?(Role.t(), binary) :: boolean

  @callback create_performer() :: {:ok, Performer.t()} | {:error, Ecto.Changeset.t()}
end
