defmodule Annacl.PerformersTest do
  use ExUnit.Case, async: true
  use Annacl.DataCase

  alias Annacl.Performers
  alias Annacl.Performers.Performer

  describe "create_performer/0" do
    test "creates the performer" do
      assert {:ok, %Performer{}} = Performers.create_performer()
    end
  end

  describe "get_performer!/1" do
    test "when the performer exists, returns the performer" do
      %{id: id} = insert!(:performer)

      assert %Performer{id: ^id} = Performers.get_performer!(id)
    end

    test "when the performer does not exist, raise an Ecto.NoResultsError" do
      assert_raise Ecto.NoResultsError, fn ->
        Performers.get_performer!(id())
      end
    end
  end

  describe "assign_role!/2" do
    test "when the role exist and does not assigned, assigned it and returns the performer with the role" do
      performer = insert!(:performer)
      role = insert!(:role, permissions: [])

      assert %Performer{roles: [^role]} = Performers.assign_role!(performer, role.name)
    end

    test "when the role does not exist and does not assigned, creates the role, assigned it and returns the performer with the role" do
      performer = insert!(:performer)
      role_params = params_for(:role)

      assert %Performer{roles: [role]} = Performers.assign_role!(performer, role_params.name)
      refute is_nil(role.id)
      assert role.name == role_params.name
    end

    test "list of roles name" do
      performer = insert!(:performer)

      role_params_1 = params_for(:role)
      role_factory_2 = insert!(:role, permissions: [])

      assert %Performer{roles: roles} =
               Performers.assign_role!(performer, [role_params_1.name, role_factory_2.name])

      role_1 = roles |> Enum.find(&(&1.id != role_factory_2.id))
      role_2 = roles |> Enum.find(&(&1.id == role_factory_2.id))

      refute is_nil(role_1.id)
      assert role_1.name == role_params_1.name

      assert role_2.id == role_factory_2.id
      assert role_2.name == role_factory_2.name
    end

    test "when the role is already assigned, returns the performer with the role" do
      performer = insert!(:performer)
      role = insert!(:role, permissions: [])
      insert!(:performer_role, performer_id: performer.id, role_id: role.id)

      assert %Performer{roles: [^role]} = Performers.assign_role!(performer, role.name)
      assert %Performer{roles: [^role]} = Performers.assign_role!(performer, [role.name])
    end
  end

  describe "remove_role!/2" do
    test "when the performer has the role, remove the role and returns the performer" do
      performer = insert!(:performer)
      role = insert!(:role)
      insert!(:performer_role, performer_id: performer.id, role_id: role.id)

      assert %Performer{roles: []} = Performers.remove_role!(performer, role.name)
    end

    test "when the performer has the roles, remove the roles and returns the performer" do
      performer = insert!(:performer)
      role_1 = insert!(:role)
      role_2 = insert!(:role)
      insert!(:performer_role, performer_id: performer.id, role_id: role_1.id)
      insert!(:performer_role, performer_id: performer.id, role_id: role_2.id)

      assert %Performer{roles: []} =
               Performers.remove_role!(performer, [role_1.name, role_2.name])
    end

    test "when the performer does not have the role, returns the performer" do
      performer = insert!(:performer, roles: [], permissions: [])
      role = insert!(:role)

      assert ^performer = Performers.remove_role!(performer, role.name)
      assert ^performer = Performers.remove_role!(performer, [role.name])
    end
  end

  describe "grant_permission!/2" do
    test "when the permission exist and does not assigned, assigned it and returns the performer with the permission" do
      performer = insert!(:performer)
      permission = insert!(:permission)

      assert %Performer{permissions: [^permission]} =
               Performers.grant_permission!(performer, permission.name)
    end

    test "when the permission does not exist and does not assigned, creates the permission, assigned it and returns the performer with the permission" do
      performer = insert!(:performer)
      permission_params = params_for(:permission)

      assert %Performer{permissions: [permission]} =
               Performers.grant_permission!(performer, permission_params.name)

      refute is_nil(permission.id)
      assert permission.name == permission_params.name
    end

    test "when the permission is already assigned, returns the performer with the permission" do
      performer = insert!(:performer)
      role = insert!(:role, permissions: [])
      insert!(:performer_role, performer_id: performer.id, role_id: role.id)

      assert %Performer{roles: [^role]} = Performers.grant_permission!(performer, role.name)
      assert %Performer{roles: [^role]} = Performers.grant_permission!(performer, [role.name])
    end

    test "when the performer already has one of the permissions through a role but not directly, returns a ok tuple" do
      performer = insert!(:performer)
      %{permissions: [permission]} = role = insert!(:role, permissions: [build(:permission)])

      insert!(:performer_role, performer_id: performer.id, role_id: role.id)

      assert %Performer{roles: [^role]} = Performers.grant_permission!(performer, permission.name)
    end
  end

  describe "revoke_permission!/2" do
    test "when the performer has the permission directly, remove the permission and returns the performer" do
      performer = insert!(:performer)
      permission = insert!(:permission)
      insert!(:performer_permission, performer_id: performer.id, permission_id: permission.id)

      assert %Performer{permissions: []} =
               Performers.revoke_permission!(performer, permission.name)
    end

    test "when the performer has the permissions, remove the permissions and returns the performer" do
      performer = insert!(:performer)
      permission_1 = insert!(:permission)
      permission_2 = insert!(:permission)
      insert!(:performer_permission, performer_id: performer.id, permission_id: permission_1.id)
      insert!(:performer_permission, performer_id: performer.id, permission_id: permission_2.id)

      assert %Performer{permissions: []} =
               Performers.revoke_permission!(performer, [permission_1.name, permission_2.name])
    end

    test "when the performer does not have the permission, returns the performer" do
      performer = insert!(:performer, roles: [], permissions: [])
      permission = insert!(:permission)

      assert ^performer = Performers.revoke_permission!(performer, permission.name)
      assert ^performer = Performers.revoke_permission!(performer, [permission.name])
    end
  end

  describe "has_role?/2" do
    test "when the performer has the role, returns true" do
      performer = insert!(:performer)
      role = insert!(:role)
      insert!(:performer_role, performer_id: performer.id, role_id: role.id)

      assert Performers.has_role?(performer, role.name)
    end

    test "when the performer does not have the role, returns false" do
      performer = insert!(:performer)
      role = insert!(:role)

      refute Performers.has_role?(performer, role.name)
      refute Performers.has_role?(performer, "role")
    end
  end

  describe "has_any_roles?/2" do
    test "when the performer has any of the role, returns true" do
      performer = insert!(:performer)
      role_1 = insert!(:role)
      role_2 = insert!(:role)
      insert!(:performer_role, performer_id: performer.id, role_id: role_1.id)

      assert Performers.has_any_roles?(performer, [role_1.name, role_2.name])
    end

    test "when the performer does not have any of the role, returns false" do
      performer = insert!(:performer)
      role_1 = insert!(:role)
      role_2 = insert!(:role)

      refute Performers.has_any_roles?(performer, [role_1.name, role_2.name])
    end
  end

  describe "has_permission?/2" do
    test "when the performer has the permission directly, returns true" do
      performer = insert!(:performer)
      permission = insert!(:permission)

      insert!(:performer_permission, performer_id: performer.id, permission_id: permission.id)

      assert Performers.has_permission?(performer, permission.name)
    end

    test "when the performer has the permission through a role, returns true" do
      %{permissions: [permission]} = role = insert!(:role, permissions: [build(:permission)])

      performer = insert!(:performer)
      insert!(:performer_role, performer_id: performer.id, role_id: role.id)

      assert Performers.has_permission?(performer, permission.name)
    end

    test "when the performer does not have the permission, returns false" do
      performer = insert!(:performer)
      permission = insert!(:permission)

      refute Performers.has_permission?(performer, permission.name)
    end
  end

  describe "has_any_permissions?/2" do
    test "when the performer has one of the permission directly, returns true" do
      performer = insert!(:performer)
      permission_1 = insert!(:permission)
      permission_2 = insert!(:permission)

      insert!(:performer_permission, performer_id: performer.id, permission_id: permission_1.id)

      assert Performers.has_any_permissions?(performer, [permission_1.name, permission_2.name])
    end

    test "when the performer has one of the permission through a role, returns true" do
      performer = insert!(:performer)

      %{permissions: [permission_1]} = role = insert!(:role, permissions: [build(:permission)])
      permission_2 = insert!(:permission)
      insert!(:performer_role, performer_id: performer.id, role_id: role.id)

      assert Performers.has_any_permissions?(performer, [permission_1.name, permission_2.name])
    end

    test "when the performer does not have the permissions, returns false" do
      performer = insert!(:performer)
      permission = insert!(:permission)

      refute Performers.has_any_permissions?(performer, [permission.name])
    end
  end

  describe "list_roles/1" do
    test "when performer has no roles" do
      performer = insert!(:performer)

      assert performer.roles == Performers.list_roles(performer)
    end
  end

  describe "list_permissions/1" do
    test "when performer has no permissions" do
      performer = insert!(:performer)
      performer = performer |> TestRepo.preload([:permissions, roles: [:permissions]])
      assert [] = Performers.list_permissions(performer)
    end

    test "when performer has permissions through roles" do
      performer = insert!(:performer)
      role = insert!(:role)
      permission = insert!(:permission)

      insert!(:permission_role, permission_id: permission.id, role_id: role.id)
      insert!(:performer_role, performer_id: performer.id, role_id: role.id)
      performer = performer |> TestRepo.preload([:permissions, roles: [:permissions]])
      assert [^permission] = Performers.list_permissions(performer)
    end

    test "when performer has direct permissions besides roles' permissions" do
      performer = insert!(:performer)
      role = insert!(:role)
      permission_1 = insert!(:permission)
      permission_2 = insert!(:permission)

      insert!(:permission_role, permission_id: permission_1.id, role_id: role.id)

      insert!(:performer_role, performer_id: performer.id, role_id: role.id)
      insert!(:performer_permission, performer_id: performer.id, permission_id: permission_2.id)

      performer = performer |> TestRepo.preload([:permissions, roles: [:permissions]])
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
