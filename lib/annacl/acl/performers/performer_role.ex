defmodule Annacl.ACL.Performers.PerformerRole do
  use Annacl.Schema

  alias Annacl.ACL.Performers.Performer
  alias Annacl.ACL.Roles.Role

  schema "annacl_performer_annacl_role" do
    belongs_to(:performer, Performer)
    belongs_to(:role, Role)

    timestamps()
  end

  def changeset(%__MODULE__{} = performer_role, attrs) when is_map(attrs) do
    performer_role
    |> cast(attrs, [:performer_id, :role_id])
    |> validate_required([:performer_id, :role_id])
    |> assoc_constraint(:performer)
    |> assoc_constraint(:role)
    |> unique_constraint(:performer_role, name: :performer_role_performer_id_role_id_index)
  end
end
