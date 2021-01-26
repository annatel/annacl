defmodule Annacl.PermissionsTest do
  use ExUnit.Case, async: true
  use Annacl.DataCase

  alias Annacl.Permissions
  alias Annacl.Permissions.Permission

  describe "create_permission/1" do
    test "when data is valid, creates the api_key" do
      permission_params = params_for(:permission)

      assert {:ok, %Permission{} = permission} = Permissions.create_permission(permission_params)
      assert permission.name == permission_params.name
    end

    test "when data is invalid, returns an error tuple with an invalid changeset" do
      assert {:error, changeset} = Permissions.create_permission(%{})

      refute changeset.valid?
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end
  end

  describe "get_permission/1" do
    test "when permission exists, returns the permission" do
      %{id: id, name: name} = insert!(:permission)

      assert %Permission{id: ^id} = Permissions.get_permission(name)
    end

    test "when permission does not exist, raises an Ecto.NoResultsError" do
      assert is_nil(Permissions.get_permission("permission"))
    end
  end

  describe "get_permission!/1" do
    test "when permission exists, returns the permission" do
      %{id: id, name: name} = insert!(:permission)

      assert %Permission{id: ^id} = Permissions.get_permission!(name)
    end

    test "when permission does not exist, raises an Ecto.NoResultsError" do
      assert_raise Ecto.NoResultsError, fn ->
        Permissions.get_permission!("permission")
      end
    end
  end

  describe "update_permission/2" do
    test "when data is valid, returns the permissions" do
      %{id: id} = permission = insert!(:permission)

      %{name: new_name} = params_for(:permission)

      assert {:ok, %Permission{id: ^id, name: ^new_name}} =
               Permissions.update_permission(permission, %{name: new_name})
    end
  end
end
