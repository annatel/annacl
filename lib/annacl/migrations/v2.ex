defmodule Annacl.Migrations.V2 do
  @moduledoc false

  use Ecto.Migration

  def up do
    create_resource_fields()
  end

  def down do
    drop_resource_fields()
  end

  defp create_resource_fields do
    alter table(:annacl_permission_annacl_role) do
      add(:resource_type, :string)
      add(:resource_id, :string)
    end

    create(index(:annacl_permission_annacl_role, [:resource_type, :resource_id]))
  end

  defp drop_resource_fields do
    drop(index(:annacl_permission_annacl_role, [:resource_type, :resource_id]))

    alter table(:annacl_permission_annacl_role) do
      remove(:resource_type)
      remove(:resource_id)
    end
  end
end
