defmodule Annacl.PermissionsRolesTest do
  use ExUnit.Case, async: true
  use Annacl.DataCase

  import Annacl.Factory

  alias Annacl.PermissionsRoles
  alias Annacl.PermissionsRoles.PermissionRole

  describe "create_permission_role/1" do
    test "when permission does not exist, returns an invalid changeset" do
      permission = build(:permission, id: 1)
      role = insert(:role)

      assert {:error, %Ecto.Changeset{} = changeset} =
               PermissionsRoles.create_permission_role(permission, role)

      refute changeset.valid?
      assert %{permission: ["does not exist"]} = errors_on(changeset)
    end

    test "when role does not exist, returns an invalid changeset" do
      permission = insert(:permission)
      role = build(:role, id: 1)

      assert {:error, %Ecto.Changeset{} = changeset} =
               PermissionsRoles.create_permission_role(permission, role)

      refute changeset.valid?
      assert %{role: ["does not exist"]} = errors_on(changeset)
    end

    test "when the role already has the permission, returns an invalid changeset" do
      permission = insert(:permission)
      role = insert(:role)
      insert(:permission_role, permission_id: permission.id, role_id: role.id)

      assert {:error, %Ecto.Changeset{} = changeset} =
               PermissionsRoles.create_permission_role(permission, role)

      refute changeset.valid?
      assert %{permission_role: ["has already been taken"]} = errors_on(changeset)
    end

    test "when data is valid, creates the permission_role" do
      permission = insert(:permission)
      role = insert(:role)

      assert {:ok, %PermissionRole{} = permission_role} =
               PermissionsRoles.create_permission_role(permission, role)

      assert permission_role.permission_id == permission.id
      assert permission_role.role_id == role.id
    end
  end

  describe "delete_permission_role/2" do
    test "when the role does not have the permission, raises an Ecto.NoResultsError" do
      permission = insert(:permission)
      role = insert(:role)

      assert_raise Ecto.NoResultsError, fn ->
        PermissionsRoles.delete_permission_role(permission, role)
      end
    end

    test "when the role has the permission, returns an invalid changeset" do
      permission = insert(:permission)
      role = insert(:role)
      insert(:permission_role, permission_id: permission.id, role_id: role.id)

      assert {:ok, %PermissionRole{} = permission_role} =
               PermissionsRoles.delete_permission_role(permission, role)

      assert permission_role.permission_id == permission.id
      assert permission_role.role_id == role.id
    end
  end
end
