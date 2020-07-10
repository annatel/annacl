defmodule Annacl.Performers.PerformerPermissionTest do
  use ExUnit.Case, async: true
  use Annacl.DataCase

  import Annacl.Factory

  alias Annacl.Performers.PerformerPermission

  describe "changeset/2" do
    test "only permitted_keys are casted" do
      performer = insert(:performer)
      permission = insert(:permission)

      performer_permission_params =
        params_for(:performer_permission, performer_id: performer.id, permission_id: permission.id)

      changeset =
        PerformerPermission.changeset(
          %PerformerPermission{},
          Map.merge(performer_permission_params, %{new_key: "value"})
        )

      changes_keys = changeset.changes |> Map.keys()

      assert :performer_id in changes_keys
      assert :permission_id in changes_keys
      refute :new_key in changes_keys
    end

    test "when required params are missing, returns an invalid changeset" do
      performer_permission_params = params_for(:performer_permission)

      changeset =
        PerformerPermission.changeset(%PerformerPermission{}, performer_permission_params)

      refute changeset.valid?
      assert %{performer_id: ["can't be blank"]} = errors_on(changeset)
      assert %{permission_id: ["can't be blank"]} = errors_on(changeset)
    end

    test "when all params are valid, returns an valid changeset" do
      performer = insert(:performer)
      permission = insert(:permission)

      performer_permission_params =
        params_for(:performer_permission, performer_id: performer.id, permission_id: permission.id)

      changeset =
        PerformerPermission.changeset(%PerformerPermission{}, performer_permission_params)

      assert changeset.valid?
    end
  end
end
