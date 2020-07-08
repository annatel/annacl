defmodule Annacl.ACL.RolesTest do
  use ExUnit.Case, async: true
  use Annacl.DataCase

  import Annacl.Factory

  alias Annacl.ACL.Roles
  alias Annacl.ACL.Roles.Role
  alias Annacl.ACL.PermissionsRoles.PermissionRole

  describe "create_role/1" do
    test "when data is invalid, returns an error tuple with an invalid changeset" do
      role_params = params_for(:role, name: nil)

      assert {:error, changeset} = Roles.create_role(role_params)

      refute changeset.valid?
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "when data is valid, creates the api_key" do
      role_params = params_for(:role)

      assert {:ok, %Role{} = role} = Roles.create_role(role_params)
      assert role.name == role_params.name
    end
  end

  describe "get_role" do
    test "when role does not exist, returns nil" do
      assert is_nil(Roles.get_role("role"))
    end

    test "when role exists, returns the role" do
      role_factory = insert(:role)

      role = Roles.get_role(role_factory.name)
      assert %Role{} = role
      assert role.id == role_factory.id
      assert role.permissions == []
    end
  end

  describe "get_role!/1" do
    test "when role does not exist, returns nil" do
      assert_raise Ecto.NoResultsError, fn ->
        Roles.get_role!("role")
      end
    end

    test "when role exists, returns the role" do
      role_factory = insert(:role)

      role = Roles.get_role!(role_factory.name)
      assert %Role{} = role
      assert role.id == role_factory.id
      assert role.permissions == []
    end
  end

  describe "grant_permission/2" do
    test "grant an already granted permission, returns an invalid changeset" do
      role = insert(:role)
      permission = insert(:permission)
      insert(:permission_role, permission_id: permission.id, role_id: role.id)

      assert {:error, %Ecto.Changeset{} = changeset} = Roles.grant_permission(role, permission)
      assert %{permission_role: ["has already been taken"]} = errors_on(changeset)
    end

    test "grant an new permission, returns the PermissionRole" do
      permission = insert(:permission)
      role = insert(:role)

      assert {:ok, %PermissionRole{} = permission_role} = Roles.grant_permission(role, permission)

      assert permission_role.permission_id == permission.id
      assert permission_role.role_id == role.id
    end
  end

  describe "revoke_permission/2" do
    test "revoke an non existing assignation, raises an Ecto.NoResultsError" do
      role = insert(:role)
      permission = insert(:permission)

      assert_raise Ecto.NoResultsError, fn ->
        Roles.revoke_permission(role, permission)
      end
    end

    test "revoke a permission from a role, returns the PermissionRole" do
      permission = insert(:permission)
      role = insert(:role)
      insert(:permission_role, permission_id: permission.id, role_id: role.id)

      assert {:ok, %PermissionRole{} = permission_role} =
               Roles.revoke_permission(role, permission)

      assert permission_role.permission_id == permission.id
      assert permission_role.role_id == role.id
    end
  end
end
