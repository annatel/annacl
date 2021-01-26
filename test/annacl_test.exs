defmodule AnnaclTest do
  use ExUnit.Case
  use Annacl.DataCase
  alias Annacl.TestAccount

  describe "assign_role!/2" do
    test "when the performer_id exists, assign the role and returns the user" do
      user = build(:user)
      role = insert!(:role)
      insert!(:performer_role, performer_id: user.performer_id, role_id: role.id)

      assert user == Annacl.assign_role!(user, role.name)
      assert user == TestAccount.assign_role!(user, role.name)
    end

    test "when the performer_id does not exist, raises an Ecto.NoResultsError" do
      user = build(:user, performer_id: 1)
      role = insert!(:role)

      assert_raise Ecto.NoResultsError, fn ->
        Annacl.assign_role!(user, role.name)
      end

      assert_raise Ecto.NoResultsError, fn ->
        TestAccount.assign_role!(user, role.name)
      end
    end
  end

  describe "remove_role!/2" do
    test "when the performer_id exists, remove the role and return the user" do
      user = build(:user)
      role = insert!(:role)

      assert user == Annacl.remove_role!(user, role.name)
      assert user == TestAccount.remove_role!(user, role.name)
    end

    test "when the performer_id exists, raises an Ecto.NoResultsError" do
      user = build(:user, performer_id: 1)
      role = insert!(:role)

      assert_raise Ecto.NoResultsError, fn ->
        Annacl.remove_role!(user, role.name)
      end

      assert_raise Ecto.NoResultsError, fn ->
        TestAccount.remove_role!(user, role.name)
      end
    end
  end

  describe "grant_permission!/2" do
    test "when the performer_id exists, grant the permission and return the user" do
      user = build(:user)
      permission = insert!(:permission)

      assert user == Annacl.grant_permission!(user, permission.name)
      assert user == TestAccount.grant_permission!(user, permission.name)
    end

    test "when the performer_id does not exist, raises an Ecto.NoResultsError" do
      user = build(:user, performer_id: id())
      permission = insert!(:permission)

      assert_raise Ecto.NoResultsError, fn ->
        Annacl.grant_permission!(user, permission.name)
      end

      assert_raise Ecto.NoResultsError, fn ->
        TestAccount.grant_permission!(user, permission.name)
      end
    end
  end

  describe "revoke_permission!/2" do
    test "when the performer_id exists, revoke the permission and returns the user" do
      user = build(:user)
      permission = insert!(:permission)

      assert user == Annacl.revoke_permission!(user, permission.name)
      assert user == TestAccount.revoke_permission!(user, permission.name)
    end

    test "when the performer_id does not exist, , raises an Ecto.NoResultsError" do
      user = build(:user, performer_id: id())
      permission = insert!(:permission)

      assert_raise Ecto.NoResultsError, fn ->
        Annacl.revoke_permission!(user, permission.name)
      end

      assert_raise Ecto.NoResultsError, fn ->
        TestAccount.revoke_permission!(user, permission.name)
      end
    end
  end

  describe "has_role?/2" do
    test "when the user has the role, returns true" do
      user = build(:user)
      role = insert!(:role)
      insert!(:performer_role, performer_id: user.performer_id, role: role)

      assert Annacl.has_role?(user, role.name)
    end

    test "when the user does not have the role but has the superadmin role, returns true" do
      user = build(:user)
      superadmin_role = build(:role) |> superadmin_role() |> insert!()

      insert!(:performer_role, performer_id: user.performer_id, role_id: superadmin_role.id)

      role = insert!(:role)

      assert Annacl.has_role?(user, role.name)
      assert TestAccount.has_role?(user, role.name)
    end

    test "when the user does not have the role, returns false" do
      user = build(:user)
      role = insert!(:role)

      refute Annacl.has_role?(user, role.name)
      refute TestAccount.has_role?(user, role.name)
    end
  end

  describe "has_permission?/2" do
    test "when the user has the permission directly, returns true" do
      user = build(:user)
      permission = insert!(:permission)

      insert!(:performer_permission,
        performer_id: user.performer_id,
        permission_id: permission.id
      )

      assert Annacl.has_permission?(user, permission.name)
      assert TestAccount.has_permission?(user, permission.name)
    end

    test "when the user has the permission through the role, returns true" do
      user = build(:user)
      %{permissions: [permission]} = role = insert!(:role, permissions: [build(:permission)])
      insert!(:performer_role, performer_id: user.performer_id, role: role)

      assert Annacl.has_permission?(user, permission.name)
      assert TestAccount.has_permission?(user, permission.name)
    end

    test "when the user does not have the permission, returns false" do
      user = build(:user)
      permission = insert!(:permission)

      refute Annacl.has_permission?(user, permission.name)
      refute TestAccount.has_permission?(user, permission.name)
    end
  end
end
