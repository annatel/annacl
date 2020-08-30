defmodule Annacl.PerformersTest do
  use ExUnit.Case, async: true
  use Annacl.DataCase

  import Annacl.Factory

  alias Annacl.Performers
  alias Annacl.Performers.{Performer, PerformerRole, PerformerPermission}

  describe "create_performer/0" do
    test "creates the performer" do
      assert {:ok, %Performer{}} = Performers.create_performer()
    end
  end

  describe "get_performer!/1" do
    test "when the performer does not exist, raise an Ecto.NoResultsError" do
      assert_raise Ecto.NoResultsError, fn ->
        Performers.get_performer!(1)
      end
    end

    test "when the performer exists, returns the performer" do
      performer_factory = insert(:performer)

      performer = Performers.get_performer!(performer_factory.id)
      assert %Performer{} = performer
      assert performer.id == performer_factory.id
    end
  end

  describe "assign_role/2 - element" do
    test "when the role does not exist, returns an invalid changeset" do
      performer = insert(:performer)
      role = build(:role, id: 1)

      assert Performers.assign_role(performer, role) == Performers.assign_role(performer, [role])
    end

    test "when the performer already has one of the roles, returns an invalid changeset" do
      performer = insert(:performer)
      role = insert(:role)
      insert(:performer_role, performer_id: performer.id, role_id: role.id)

      assert Performers.assign_role(performer, role) == Performers.assign_role(performer, [role])
    end

    test "when the performer does not have the role, returns a ok tuple" do
      performer = insert(:performer)
      role = insert(:role)

      assert {:ok, %PerformerRole{} = performer_role} = Performers.assign_role(performer, role)

      assert performer_role.performer_id == performer.id
      assert performer_role.role_id == role.id
    end
  end

  describe "assign_role/2 - list" do
    test "when one of the roles does not exist, returns an invalid changeset" do
      performer = insert(:performer)
      role_1 = insert(:role, id: 1)
      role_2 = build(:role, id: 2)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Performers.assign_role(performer, [role_1, role_2])

      refute changeset.valid?
      assert %{role: ["does not exist"]} = errors_on(changeset)
    end

    test "when the performer already has one of the roles, returns an invalid changeset" do
      performer = insert(:performer)
      role_1 = insert(:role)
      insert(:performer_role, performer_id: performer.id, role_id: role_1.id)

      role_2 = insert(:role)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Performers.assign_role(performer, [role_1, role_2])

      refute changeset.valid?
      assert %{performer_role: ["has already been taken"]} = errors_on(changeset)
    end

    test "when the performer does not have the roles, returns a ok tuple" do
      performer = insert(:performer)
      role_1 = insert(:role)
      role_2 = insert(:role)

      assert {:ok, performer_roles} = Performers.assign_role(performer, [role_1, role_2])

      assert performer_roles
             |> Enum.map(&%{performer_id: &1.performer_id, role_id: &1.role_id})
             |> Enum.member?(%{performer_id: performer.id, role_id: role_1.id})

      assert performer_roles
             |> Enum.map(&%{performer_id: &1.performer_id, role_id: &1.role_id})
             |> Enum.member?(%{performer_id: performer.id, role_id: role_2.id})
    end
  end

  describe "remove_role/2" do
    test "when the performer does not have the role, raise an Ecto.NoResultsError" do
      performer = insert(:performer)
      role = insert(:role)

      assert_raise Ecto.NoResultsError, fn ->
        Performers.remove_role(performer, role)
      end
    end

    test "when the performer has the role, return an ok tuple" do
      performer = insert(:performer)
      role = insert(:role)
      insert(:performer_role, performer_id: performer.id, role_id: role.id)

      assert {:ok, %PerformerRole{} = performer_role} = Performers.remove_role(performer, role)
    end
  end

  describe "grant_permission/2 - element" do
    test "when the permission does not exist, returns an invalid changeset" do
      performer = insert(:performer)
      permission = build(:permission, id: 1)

      assert Performers.grant_permission(performer, permission) ==
               Performers.grant_permission(performer, [permission])
    end

    test "when the performer already has one of the permissions, returns an invalid changeset" do
      performer = insert(:performer)
      permission = insert(:permission)
      insert(:performer_permission, performer_id: performer.id, permission_id: permission.id)

      assert Performers.grant_permission(performer, permission) ==
               Performers.grant_permission(performer, [permission])
    end

    test "when the performer already has one of the permissions through a role but not directly, returns a ok tuple" do
      performer = insert(:performer)
      permission = insert(:permission)
      role = insert(:role)

      insert(:performer_role, performer_id: performer.id, role_id: role.id)
      insert(:permission_role, permission_id: permission.id, role_id: role.id)

      assert {:ok, performer_permission} = Performers.grant_permission(performer, permission)

      assert performer_permission.performer_id == performer.id
      assert performer_permission.permission_id == permission.id
    end

    test "when the performer does not have the permission, returns a ok tuple" do
      performer = insert(:performer)
      permission = insert(:permission)

      assert {:ok, %PerformerPermission{} = performer_permission} =
               Performers.grant_permission(performer, permission)

      assert performer_permission.performer_id == performer.id
      assert performer_permission.permission_id == permission.id
    end
  end

  describe "grant_permission/2 - list" do
    test "when one of the permission does not exist, returns an invalid changeset" do
      performer = insert(:performer)
      permission_1 = insert(:permission, id: 1)
      permission_2 = build(:permission, id: 2)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Performers.grant_permission(performer, [permission_1, permission_2])

      refute changeset.valid?
      assert %{permission: ["does not exist"]} = errors_on(changeset)
    end

    test "when the performer already has one of the permissions, returns an invalid changeset" do
      performer = insert(:performer)
      permission_1 = insert(:permission)
      insert(:performer_permission, performer_id: performer.id, permission_id: permission_1.id)

      permission_2 = insert(:permission)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Performers.grant_permission(performer, [permission_1, permission_2])

      refute changeset.valid?
      assert %{performer_permission: ["has already been taken"]} = errors_on(changeset)
    end

    test "when the performer already has one of the permissions through a role, returns a ok tuple" do
      performer = insert(:performer)
      permission = insert(:permission)
      role = insert(:role)

      insert(:performer_role, performer_id: performer.id, role_id: role.id)
      insert(:permission_role, permission_id: permission.id, role_id: role.id)

      assert {:ok, performer_permissions} = Performers.grant_permission(performer, [permission])

      assert performer_permissions
             |> Enum.map(&%{performer_id: &1.performer_id, permission_id: &1.permission_id})
             |> Enum.member?(%{performer_id: performer.id, permission_id: permission.id})
    end

    test "when the performer does not have the permissions, returns a ok tuple" do
      performer = insert(:performer)
      permission_1 = insert(:permission)
      permission_2 = insert(:permission)

      assert {:ok, performer_permissions} =
               Performers.grant_permission(performer, [permission_1, permission_2])

      assert performer_permissions
             |> Enum.map(&%{performer_id: &1.performer_id, permission_id: &1.permission_id})
             |> Enum.member?(%{performer_id: performer.id, permission_id: permission_1.id})

      assert performer_permissions
             |> Enum.map(&%{performer_id: &1.performer_id, permission_id: &1.permission_id})
             |> Enum.member?(%{performer_id: performer.id, permission_id: permission_2.id})
    end
  end

  describe "revoke_permission/2" do
    test "when the performer does not have the permission, raise an Ecto.NoResultError" do
      performer = insert(:performer)
      permission = insert(:permission)

      assert_raise Ecto.NoResultsError, fn ->
        Performers.revoke_permission(performer, permission)
      end
    end

    test "when the performer hase the permission, return an ok tuple" do
      performer = insert(:performer)
      permission = insert(:permission)
      insert(:performer_permission, performer_id: performer.id, permission_id: permission.id)

      assert {:ok, %PerformerPermission{} = performer_permission} =
               Performers.revoke_permission(performer, permission)
    end
  end

  describe "has_role?/2 - element" do
    test "when the performer does not have the role, returns false" do
      performer = insert(:performer)
      role = insert(:role)

      assert Performers.has_role?(performer, role) == Performers.has_role?(performer, [role])
    end

    test "when the performer has the role, returns true" do
      performer = insert(:performer)
      role = insert(:role)
      insert(:performer_role, performer_id: performer.id, role_id: role.id)

      assert Performers.has_role?(performer, role) == Performers.has_role?(performer, [role])
    end
  end

  describe "has_role?/2 - list" do
    test "when the performer does not have any of the role, returns false" do
      performer = insert(:performer)
      role_1 = insert(:role)
      role_2 = insert(:role)

      refute Performers.has_role?(performer, [role_1, role_2])
    end

    test "when the performer has any of the role, returns true" do
      performer = insert(:performer)
      role_1 = insert(:role)
      role_2 = insert(:role)
      insert(:performer_role, performer_id: performer.id, role_id: role_1.id)

      assert Performers.has_role?(performer, [role_1, role_2])
    end
  end

  describe "can?/2 - element" do
    test "when the performer does not have the permission, returns false" do
      performer = insert(:performer)
      permission = insert(:permission)

      assert Performers.can?(performer, permission) == Performers.can?(performer, [permission])
    end

    test "when the performer has the permission through a role, returns true" do
      performer = insert(:performer)
      permission = insert(:permission)
      role = insert(:role)
      insert(:permission_role, permission_id: permission.id, role_id: role.id)
      insert(:performer_role, performer_id: performer.id, role_id: role.id)

      assert Performers.can?(performer, permission) == Performers.can?(performer, [permission])
    end

    test "when the performer has the permission directly, returns true" do
      performer = insert(:performer)
      permission = insert(:permission)

      insert(:performer_permission, performer_id: performer.id, permission_id: permission.id)

      assert Performers.can?(performer, permission) == Performers.can?(performer, [permission])
    end
  end

  describe "can?/2 - list" do
    test "when the performer does not have the permissions, returns false" do
      performer = insert(:performer)
      permission = insert(:permission)

      refute Performers.can?(performer, [permission])
    end

    test "when the performer has one of the permission through a role, returns true" do
      performer = insert(:performer)
      permission_1 = insert(:permission)
      permission_2 = insert(:permission)
      role = insert(:role)
      insert(:permission_role, permission_id: permission_1.id, role_id: role.id)
      insert(:performer_role, performer_id: performer.id, role_id: role.id)

      assert Performers.can?(performer, [permission_1, permission_2])
    end

    test "when the performer has one of the permission directly, returns true" do
      performer = insert(:performer)
      permission_1 = insert(:permission)
      permission_2 = insert(:permission)

      insert(:performer_permission, performer_id: performer.id, permission_id: permission_1.id)

      assert Performers.can?(performer, [permission_1, permission_2])
    end
  end

  describe "list_roles/1" do
    test "when performer has no roles" do
      performer = insert(:performer)

      assert [] = Performers.list_roles(performer)
    end

    test "when performer has roles" do
      performer = insert(:performer)
      role = insert(:role)
      insert(:performer_role, performer_id: performer.id, role_id: role.id)

      assert [role] = Performers.list_roles(performer)
    end
  end

  describe "list_permissions/1" do
    test "when performer has no permissions" do
      performer = insert(:performer)

      assert [] = Performers.list_permissions(performer)
    end

    test "when performer has permissions through roles" do
      performer = insert(:performer)
      role = insert(:role)
      permission = insert(:permission)

      insert(:permission_role, permission_id: permission.id, role_id: role.id)
      insert(:performer_role, performer_id: performer.id, role_id: role.id)

      assert [permission] = Performers.list_permissions(performer)
    end

    test "when performer has direct permissions besides roles' permissions" do
      performer = insert(:performer)
      role = insert(:role)
      permission_1 = insert(:permission)
      permission_2 = insert(:permission)

      insert(:permission_role, permission_id: permission_1.id, role_id: role.id)

      insert(:performer_role, performer_id: performer.id, role_id: role.id)
      insert(:performer_permission, performer_id: performer.id, permission_id: permission_2.id)

      assert performer_permissions = Performers.list_permissions(performer)

      assert performer_permissions
             |> Enum.map(&%{permission_id: &1.id})
             |> Enum.member?(%{permission_id: permission_1.id})

      assert performer_permissions
             |> Enum.map(&%{permission_id: &1.id})
             |> Enum.member?(%{permission_id: permission_2.id})
    end
  end
end
