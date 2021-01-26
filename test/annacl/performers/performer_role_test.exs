defmodule Annacl.Performers.PerformerRoleTest do
  use ExUnit.Case, async: true
  use Annacl.DataCase

  alias Annacl.Performers.PerformerRole

  describe "changeset/2" do
    test "only permitted_keys are casted" do
      performer_role_params = params_for(:performer_role, performer_id: id(), role_id: id())

      changeset =
        PerformerRole.changeset(
          %PerformerRole{},
          Map.merge(performer_role_params, %{new_key: "value"})
        )

      changes_keys = changeset.changes |> Map.keys()

      assert :performer_id in changes_keys
      assert :role_id in changes_keys
      refute :new_key in changes_keys
    end

    test "when all params are valid, returns an valid changeset" do
      performer = insert!(:performer)
      role = insert!(:role)

      performer_role_params =
        params_for(:performer_role, performer_id: performer.id, role_id: role.id)

      changeset = PerformerRole.changeset(%PerformerRole{}, performer_role_params)

      assert changeset.valid?
    end

    test "when required params are missing, returns an invalid changeset" do
      changeset = PerformerRole.changeset(%PerformerRole{}, %{})

      refute changeset.valid?
      assert %{performer_id: ["can't be blank"]} = errors_on(changeset)
      assert %{role_id: ["can't be blank"]} = errors_on(changeset)
    end
  end
end
