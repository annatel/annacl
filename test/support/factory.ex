defmodule Annacl.Factory do
  use Annacl.Factory.Permission
  use Annacl.Factory.Role
  use Annacl.Factory.PermissionRole

  use Annacl.Factory.Performer
  use Annacl.Factory.User

  @spec uuid :: <<_::288>>
  def uuid(), do: Ecto.UUID.generate()

  @spec id :: integer
  def id(), do: System.unique_integer([:positive])

  @spec utc_now :: DateTime.t()
  def utc_now(), do: DateTime.utc_now() |> DateTime.truncate(:second)

  @spec add(DateTime.t(), integer, System.time_unit()) :: DateTime.t()
  def add(%DateTime{} = datetime, amount_of_time, time_unit \\ :second) do
    datetime |> DateTime.add(amount_of_time, time_unit)
  end

  @spec params_for(struct) :: map
  def params_for(schema) when is_struct(schema) do
    schema
    |> AntlUtilsEcto.map_from_struct()
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Enum.into(%{})
  end

  @spec params_for(atom, Enum.t()) :: map
  def params_for(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> params_for()
  end

  @spec build(atom, Enum.t()) :: %{:__struct__ => atom, optional(atom) => any}
  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  @spec insert!(atom, Enum.t()) :: any
  def insert!(factory_name, attributes)
      when is_atom(factory_name) or is_tuple(factory_name) do
    factory_name |> build(attributes) |> insert!()
  end

  @spec insert!(atom | tuple | struct) :: struct
  def insert!(factory_name) when is_atom(factory_name) or is_tuple(factory_name) do
    factory_name |> build([]) |> insert!()
  end

  def insert!(schema) when is_struct(schema) do
    schema |> Annacl.repo().insert!()
  end
end
