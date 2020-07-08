defmodule Annacl.ACL.Permissions.PermissionTest do
  use ExUnit.Case, async: true
  use Annacl.DataCase

  import Annacl.Factory

  alias Annacl.ACL.Permissions.Permission

  describe "changeset/2" do
    test "only permitted_keys are casted" do
      permission_params = params_for(:permission)

      changeset =
        Permission.changeset(%Permission{}, Map.merge(permission_params, %{new_key: "value"}))

      changes_keys = changeset.changes |> Map.keys()

      assert :name in changes_keys
      refute :new_key in changes_keys
    end

    test "when required params are missing, returns an invalid changeset" do
      permission_params = params_for(:permission, name: nil)

      changeset = Permission.changeset(%Permission{}, permission_params)

      refute changeset.valid?
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "when all params are valid, returns an valid changeset" do
      permission_params = params_for(:permission)

      changeset = Permission.changeset(%Permission{}, permission_params)

      assert changeset.valid?
    end
  end
end
