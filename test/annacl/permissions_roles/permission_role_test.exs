defmodule Annacl.PermissionsRoles.PermissionRoleTest do
  use ExUnit.Case, async: true
  use Annacl.DataCase

  import Annacl.Factory

  alias Annacl.PermissionsRoles.PermissionRole

  describe "changeset/2" do
    test "only permitted_keys are casted" do
      permission = insert(:permission)
      role = insert(:role)

      permission_role_params =
        params_for(:permission_role, permission_id: permission.id, role_id: role.id)

      changeset =
        PermissionRole.changeset(
          %PermissionRole{},
          Map.merge(permission_role_params, %{new_key: "value"})
        )

      changes_keys = changeset.changes |> Map.keys()

      assert :permission_id in changes_keys
      assert :role_id in changes_keys
      refute :new_key in changes_keys
    end

    test "when required params are missing, returns an invalid changeset" do
      permission_role_params = params_for(:permission_role)

      changeset = PermissionRole.changeset(%PermissionRole{}, permission_role_params)

      refute changeset.valid?
      assert %{permission_id: ["can't be blank"]} = errors_on(changeset)
      assert %{role_id: ["can't be blank"]} = errors_on(changeset)
    end

    test "when all params are valid, returns an valid changeset" do
      permission = insert(:permission)
      role = insert(:role)

      permission_role_params =
        params_for(:permission_role, permission_id: permission.id, role_id: role.id)

      changeset = PermissionRole.changeset(%PermissionRole{}, permission_role_params)

      assert changeset.valid?
    end
  end
end
