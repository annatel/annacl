defmodule Annacl.RolesTest do
  use ExUnit.Case, async: true
  use Annacl.DataCase

  alias Annacl.Roles
  alias Annacl.Roles.Role

  describe "create_role/1" do
    test "when data is valid, creates the api_key" do
      role_params = params_for(:role)

      assert {:ok, %Role{} = role} = Roles.create_role(role_params)
      assert role.name == role_params.name
    end

    test "when data is invalid, returns an error tuple with an invalid changeset" do
      assert {:error, changeset} = Roles.create_role(%{})

      refute changeset.valid?
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end
  end

  describe "get_role/1" do
    test "when the role exists, returns the role" do
      %{id: id, name: name} = insert!(:role)

      assert %Role{id: ^id, name: ^name, permissions: []} = Roles.get_role(name)
    end

    test "when role does not exist, returns nil" do
      assert is_nil(Roles.get_role("role"))
    end
  end

  describe "get_role!/1" do
    test "when role exists, returns the role" do
      %{id: id, name: name} = insert!(:role)

      assert %Role{id: ^id, name: ^name, permissions: []} = Roles.get_role!(name)
    end

    test "when role does not exist, returns nil" do
      assert_raise Ecto.NoResultsError, fn ->
        Roles.get_role!("role")
      end
    end
  end

  describe "grant_permission!/2" do
    test "grant an non existing permission, create the permission, grant it to the role and returns the role" do
      role = insert!(:role)
      permission_params = params_for(:permission)

      %Role{permissions: [permission]} = Roles.grant_permission!(role, permission_params.name)

      refute is_nil(permission.id)
      assert permission.name == permission_params.name
    end

    test "grant an existing permission, grant it to the role and returns the role" do
      role = insert!(:role)
      permission = insert!(:permission)

      assert %Role{permissions: [^permission]} = Roles.grant_permission!(role, permission.name)
    end

    test "grant an already granted permission, returns the role" do
      role = insert!(:role)
      permission = insert!(:permission)
      insert!(:permission_role, permission_id: permission.id, role_id: role.id)

      assert %Role{permissions: [^permission]} = Roles.grant_permission!(role, permission.name)
    end
  end

  describe "revoke_permission/2" do
    test "revoke a granted permission, returns the role" do
      permission_1 = insert!(:permission)
      permission_2 = insert!(:permission)

      role = insert!(:role)

      insert!(:permission_role, permission_id: permission_1.id, role_id: role.id)
      insert!(:permission_role, permission_id: permission_2.id, role_id: role.id)

      assert %Role{permissions: [^permission_2]} =
               Roles.revoke_permission!(role, permission_1.name)
    end

    test "revoke a non granted permission, returns the role" do
      permission = insert!(:permission)

      role = insert!(:role)

      assert %Role{permissions: []} = Roles.revoke_permission!(role, permission.name)
    end
  end
end
