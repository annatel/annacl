defmodule AnnaclTest do
  use ExUnit.Case
  use Annacl.DataCase

  describe "assign_role!/2" do
    test "when role does not exist, raises a Ecto.NoResultsError" do
      user = build(:user)

      assert_raise Ecto.NoResultsError, fn ->
        Annacl.assign_role!(user, "new_role")
      end
    end

    test "when user's performer_id does not exist, raises an Ecto.NoResultsError" do
      user = build(:user, performer_id: Annacl.Factory.uuid())
      role = insert(:role)

      assert_raise Ecto.NoResultsError, fn ->
        Annacl.assign_role!(user, role.name)
      end
    end

    test "when user already has the role, returns an error tuple" do
      user = build(:user)
      role = insert(:role)
      insert(:performer_role, performer_id: user.performer_id, role_id: role.id)

      assert {:error, _} = Annacl.assign_role!(user, role.name)
    end

    test "when user does not have the role, assign the role" do
      user = build(:user)
      role = insert(:role)

      assert {:ok, _} = Annacl.assign_role!(user, role.name)
    end
  end

  describe "remove_role!/2" do
    test "when role does not exist, raises a Ecto.NoResultsError" do
      user = build(:user)

      assert_raise Ecto.NoResultsError, fn ->
        Annacl.remove_role!(user, "new_role")
      end
    end

    test "when user's performer_id does not exist, raises an Ecto.NoResultsError" do
      user = build(:user, performer_id: Annacl.Factory.uuid())
      role = insert(:role)

      assert_raise Ecto.NoResultsError, fn ->
        Annacl.remove_role!(user, role.name)
      end
    end

    test "when user does not have the role, raises an Ecto.NoResultsError" do
      user = build(:user)
      role = insert(:role)

      assert_raise Ecto.NoResultsError, fn ->
        Annacl.remove_role!(user, role.name)
      end
    end

    test "when user does not have the role, assign the role" do
      user = build(:user)
      role = insert(:role)
      insert(:performer_role, performer_id: user.performer_id, role_id: role.id)

      assert {:ok, _} = Annacl.remove_role!(user, role.name)
    end
  end

  describe "grant_permission!/2" do
    test "when permission does not exist, raises a Ecto.NoResultsError" do
      user = build(:user)

      assert_raise Ecto.NoResultsError, fn ->
        Annacl.grant_permission!(user, "new_permission")
      end
    end

    test "when user's performer_id does not exist, raises an Ecto.NoResultsError" do
      user = build(:user, performer_id: Annacl.Factory.uuid())
      permission = insert(:permission)

      assert_raise Ecto.NoResultsError, fn ->
        Annacl.grant_permission!(user, permission.name)
      end
    end

    test "when user already has the permission, returns an error tuple" do
      user = build(:user)
      permission = insert(:permission)

      insert(:performer_permission,
        performer_id: user.performer_id,
        permission_id: permission.id
      )

      assert {:error, _} = Annacl.grant_permission!(user, permission.name)
    end

    test "when user does not have the permission, assign the permission" do
      user = build(:user)
      permission = insert(:permission)

      assert {:ok, _} = Annacl.grant_permission!(user, permission.name)
    end
  end

  describe "revoke_permission!/2" do
    test "when permission does not exist, raises a Ecto.NoResultsError" do
      user = build(:user)

      assert_raise Ecto.NoResultsError, fn ->
        Annacl.revoke_permission!(user, "new_permission")
      end
    end

    test "when user's performer_id does not exist, raises an Ecto.NoResultsError" do
      user = build(:user, performer_id: Annacl.Factory.uuid())
      permission = insert(:permission)

      assert_raise Ecto.NoResultsError, fn ->
        Annacl.revoke_permission!(user, permission.name)
      end
    end

    test "when user does not have the permission, raises an Ecto.NoResultsError" do
      user = build(:user)
      permission = insert(:permission)

      assert_raise Ecto.NoResultsError, fn ->
        Annacl.revoke_permission!(user, permission.name)
      end
    end

    test "when user does not have the permission, assign the permission" do
      user = build(:user)
      permission = insert(:permission)

      insert(:performer_permission,
        performer_id: user.performer_id,
        permission_id: permission.id
      )

      assert {:ok, _} = Annacl.revoke_permission!(user, permission.name)
    end
  end

  describe "has_role?/2" do
    test "when the user does not have the role, returns false" do
      user = build(:user)
      role = insert(:role)

      refute Annacl.has_role?(user, role.name)
    end

    test "when the user has the role, returns true" do
      user = build(:user)
      role = insert(:role)
      insert(:performer_role, performer_id: user.performer_id, role: role)

      assert Annacl.has_role?(user, role.name)
    end

    test "when the user does not have the role but has the superadmin role, returns true" do
      user = build(:user)
      superadmin_role_params = params_for(:role) |> role_superadmin()
      superadmin_role = insert(:role, superadmin_role_params)
      insert(:performer_role, performer_id: user.performer_id, role: superadmin_role)

      role = insert(:role)

      assert Annacl.has_role?(user, role.name)
    end
  end

  describe "can?/2" do
    test "when the user does not have the permission, returns false" do
      user = build(:user)
      permission = insert(:permission)

      refute Annacl.can?(user, permission.name)
    end

    test "when the user has the permission through the role, returns true" do
      user = build(:user)
      permission = insert(:permission)
      role = insert(:role)
      insert(:permission_role, permission: permission, role: role)
      insert(:performer_role, performer_id: user.performer_id, role: role)

      assert Annacl.can?(user, permission.name)
    end

    test "when the user has the permission directly, returns true" do
      user = build(:user)
      permission = insert(:permission)

      insert(:performer_permission,
        performer_id: user.performer_id,
        permission_id: permission.id
      )

      assert Annacl.can?(user, permission.name)
    end

    test "when the user does not have the permission but has the superadmin role, returns true" do
      user = build(:user)
      superadmin_role_params = params_for(:role) |> role_superadmin()
      superadmin_role = insert(:role, superadmin_role_params)
      insert(:performer_role, performer_id: user.performer_id, role: superadmin_role)

      permission = insert(:permission)

      assert Annacl.can?(user, permission.name)
    end
  end
end
