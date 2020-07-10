defmodule Annacl.Permissions.Permission do
  @moduledoc """
  Ecto Schema that represent a permission.
  """
  use Annacl.Schema

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
