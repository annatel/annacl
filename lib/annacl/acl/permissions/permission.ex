defmodule Annacl.ACL.Permissions.Permission do
  use Annacl.Schema

  schema "annacl_permissions" do
    field(:name, :string)

    timestamps()
  end

  def changeset(%__MODULE__{} = permission, attrs) when is_map(attrs) do
    permission
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
