defmodule Annacl.ACL.Performers.PerformerTest do
  use ExUnit.Case, async: true
  use Annacl.DataCase

  import Annacl.Factory

  alias Annacl.ACL.Performers.Performer

  describe "changeset/2" do
    test "only permitted_keys are casted" do
      performer_params = params_for(:performer)

      changeset =
        Performer.changeset(%Performer{}, Map.merge(performer_params, %{new_key: "value"}))

      changes_keys = changeset.changes |> Map.keys()

      refute :new_key in changes_keys
    end

    test "when all params are valid, returns an valid changeset" do
      performer_params = params_for(:performer)

      changeset = Performer.changeset(%Performer{}, performer_params)

      assert changeset.valid?
    end
  end
end
