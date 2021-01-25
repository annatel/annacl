defmodule Annacl.Permissions.Permission do
  @moduledoc """
  Ecto Schema that represent a permission.
  """
  use Ecto.Schema

  import Ecto.Changeset,
    only: [cast: 3, validate_required: 2, unique_constraint: 2]

  @type t :: %__MODULE__{
          id: integer,
          inserted_at: DateTime.t(),
          name: binary,
          updated_at: DateTime.t()
        }

  schema "annacl_permissions" do
    field(:name, :string)

    timestamps()
  end

  @spec changeset(Permission.t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = permission, attrs) when is_map(attrs) do
    permission
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
