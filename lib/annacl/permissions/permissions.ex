defmodule Annacl.Permissions do
  @moduledoc false

  import Ecto.Query, only: [where: 2]

  alias Annacl.Permissions.Permission

  @spec create_permission(map) :: {:ok, Permission.t()} | {:error, Ecto.Changeset.t()}
  def create_permission(attrs) when is_map(attrs) do
    %Permission{}
    |> Permission.changeset(attrs)
    |> Annacl.repo().insert()
  end

  @spec get_permission(binary) :: Permission.t() | nil
  def get_permission(name) when is_binary(name) do
    Permission
    |> where(name: ^name)
    |> Annacl.repo().one()
  end

  @spec get_permission!(binary) :: Permission.t()
  def get_permission!(name) when is_binary(name) do
    Permission
    |> where(name: ^name)
    |> Annacl.repo().one!()
  end

  @spec update_permission(Permission.t(), map) ::
          {:ok, Permission.t()} | {:error, Ecto.Changeset.t()}
  def update_permission(%Permission{} = permission, attrs) when is_map(attrs) do
    permission
    |> Permission.changeset(attrs)
    |> Annacl.repo().update()
  end
end
