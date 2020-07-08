defmodule Annacl.ACL.Roles.RoleTest do
  use ExUnit.Case, async: true
  use Annacl.DataCase

  alias Annacl.ACL.Roles.Role

  describe "changeset/2" do
    test "only permitted_keys are casted" do
      role_params = params_for(:role)

      changeset = Role.changeset(%Role{}, Map.merge(role_params, %{new_key: "value"}))

      changes_keys = changeset.changes |> Map.keys()

      assert :name in changes_keys
      refute :new_key in changes_keys
    end

    test "when required params are missing, returns an invalid changeset" do
      role_params = params_for(:role, name: nil)

      changeset = Role.changeset(%Role{}, role_params)

      refute changeset.valid?
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "when all params are valid, returns an valid changeset" do
      role_params = params_for(:role)

      changeset = Role.changeset(%Role{}, role_params)

      assert changeset.valid?
    end
  end
end
