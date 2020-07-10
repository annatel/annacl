defmodule Annacl.PermissionsTest do
  use ExUnit.Case, async: true
  use Annacl.DataCase

  import Annacl.Factory

  alias Annacl.Permissions
  alias Annacl.Permissions.Permission
  alias Annacl.PermissionsRoles.PermissionRole

  describe "create_permission/1" do
    test "when data is invalid, returns an error tuple with an invalid changeset" do
      permission_params = params_for(:permission, name: nil)

      assert {:error, changeset} = Permissions.create_permission(permission_params)

      refute changeset.valid?
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "when data is valid, creates the api_key" do
      permission_params = params_for(:permission)

      assert {:ok, %Permission{} = permission} = Permissions.create_permission(permission_params)
      assert permission.name == permission_params.name
    end
  end

  describe "get_permission" do
    test "when permission does not exist, raises an Ecto.NoResultsError" do
      assert_raise Ecto.NoResultsError, fn ->
        Permissions.get_permission!("permission")
      end
    end

    test "when permission exists, returns the permission" do
      permission_factory = insert(:permission)

      permission = Permissions.get_permission!(permission_factory.name)
      assert %Permission{} = permission
      assert permission.id == permission_factory.id
    end
  end

  describe "assign_role/2" do
    test "assign an already assigned role, returns an invalid changeset" do
      role = insert(:role)
      permission = insert(:permission)
      insert(:permission_role, permission_id: permission.id, role_id: role.id)

      assert {:error, %Ecto.Changeset{} = changeset} = Permissions.assign_role(permission, role)

      refute changeset.valid?
      assert %{permission_role: ["has already been taken"]} = errors_on(changeset)
    end

    test "assign a new role, returns the PermissionRole" do
      permission = insert(:permission)
      role = insert(:role)

      assert {:ok, %PermissionRole{} = permission_role} =
               Permissions.assign_role(permission, role)

      assert permission_role.permission_id == permission.id
      assert permission_role.role_id == role.id
    end
  end

  describe "remove_role/2" do
    test "remove an non existing assignation, raises an Ecto.NoResultsError" do
      role = insert(:role)
      permission = insert(:permission)

      assert_raise Ecto.NoResultsError, fn ->
        Permissions.remove_role(permission, role)
      end
    end

    test "remove a role from a permission, returns the PermissionRole" do
      permission = insert(:permission)
      role = insert(:role)
      insert(:permission_role, permission_id: permission.id, role_id: role.id)

      assert {:ok, %PermissionRole{} = permission_role} =
               Permissions.remove_role(permission, role)

      assert permission_role.permission_id == permission.id
      assert permission_role.role_id == role.id
    end
  end
end
