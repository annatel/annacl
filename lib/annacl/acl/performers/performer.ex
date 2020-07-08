defmodule Annacl.ACL.Performers.Performer do
  use Annacl.Schema

  alias Annacl.ACL.Permissions.Permission
  alias Annacl.ACL.Roles.Role
  alias Annacl.ACL.Performers.PerformerPermission
  alias Annacl.ACL.Performers.PerformerRole

  schema "annacl_performers" do
    many_to_many(:permissions, Permission, join_through: PerformerPermission)
    many_to_many(:roles, Role, join_through: PerformerRole)

    timestamps()
  end

  def changeset(%__MODULE__{} = performer, attrs) when is_map(attrs) do
    performer
    |> cast(attrs, [])
  end
end
