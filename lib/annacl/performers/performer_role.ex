defmodule Annacl.Performers.PerformerRole do
  @moduledoc """
  Ecto Schema that represent an association between a performer and a role.
  """
  use Ecto.Schema

  import Ecto.Changeset,
    only: [cast: 3, validate_required: 2, assoc_constraint: 2, unique_constraint: 3]

  alias Annacl.Performers.Performer
  alias Annacl.Roles.Role

  @type t :: %__MODULE__{
          id: integer,
          inserted_at: DateTime.t(),
          performer_id: integer,
          role_id: integer,
          updated_at: DateTime.t()
        }

  schema "annacl_performer_annacl_role" do
    belongs_to(:performer, Performer)
    belongs_to(:role, Role)

    timestamps()
  end

  @spec changeset(PerformerRole.t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = performer_role, attrs) when is_map(attrs) do
    performer_role
    |> cast(attrs, [:performer_id, :role_id])
    |> validate_required([:performer_id, :role_id])
    |> assoc_constraint(:performer)
    |> assoc_constraint(:role)
    |> unique_constraint(:performer_role, name: :performer_role_performer_id_role_id_index)
  end
end
