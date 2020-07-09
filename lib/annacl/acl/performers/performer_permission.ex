defmodule Annacl.ACL.Performers.PerformerPermission do
  @moduledoc """
  Ecto Schema that represent an association between a performer and a permission.
  """
  use Annacl.Schema

  alias Annacl.ACL.Performers.Performer
  alias Annacl.ACL.Permissions.Permission

  schema "annacl_performer_annacl_permission" do
    belongs_to(:performer, Performer)
    belongs_to(:permission, Permission)

    timestamps()
  end

  @spec changeset(PerformerPermission.t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = performer_permission, attrs) when is_map(attrs) do
    performer_permission
    |> cast(attrs, [:performer_id, :permission_id])
    |> validate_required([:performer_id, :permission_id])
    |> assoc_constraint(:performer)
    |> assoc_constraint(:permission)
    |> unique_constraint(:performer_permission,
      name: :performer_permission_performer_id_permission_id_index
    )
  end
end
