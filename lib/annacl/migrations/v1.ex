defmodule Annacl.Migrations.V1 do
  @moduledoc false

  use Ecto.Migration

  def up do
    create_permissions_table()
    create_roles_table()
    create_permission_role_table()
    create_performers_table()
    create_performer_role_table()
    create_performer_permission_table()
  end

  def down do
    drop_permissions_table()
    drop_roles_table()
    drop_permission_role_table()
    drop_performers_table()
    drop_performer_role_table()
    drop_performer_permission_table()
  end

  defp create_permissions_table do
    create table(:annacl_permissions) do
      add(:name, :string)

      timestamps()
    end

    create(unique_index(:annacl_permissions, [:name]))
  end

  defp drop_permissions_table do
    drop(table(:annacl_permissions), mode: :cascade)
  end

  defp create_roles_table do
    create table(:annacl_roles) do
      add(:name, :string)

      timestamps()
    end

    create(unique_index(:annacl_roles, [:name]))
  end

  defp drop_roles_table do
    drop(table(:annacl_roles), mode: :cascade)
  end

  defp create_permission_role_table do
    create table(:annacl_permission_annacl_role) do
      add(:role_id, references(:annacl_roles, on_delete: :delete_all))
      add(:permission_id, references(:annacl_permissions, on_delete: :delete_all))

      timestamps()
    end

    create(
      unique_index(:annacl_permission_annacl_role, [:permission_id, :role_id],
        name: "permission_role_permission_id_role_id_index"
      )
    )
  end

  defp drop_permission_role_table do
    drop(table(:annacl_permission_annacl_role))
  end

  defp create_performers_table do
    create table(:annacl_performers) do
      timestamps()
    end
  end

  defp drop_performers_table do
    drop(table(:annacl_performers), mode: :cascade)
  end

  defp create_performer_role_table do
    create table(:annacl_performer_annacl_role) do
      add(:performer_id, references(:annacl_performers, on_delete: :delete_all))
      add(:role_id, references(:annacl_roles, on_delete: :delete_all))

      timestamps()
    end

    create(
      unique_index(:annacl_performer_annacl_role, [:performer_id, :role_id],
        name: "performer_role_performer_id_role_id_index"
      )
    )
  end

  defp drop_performer_role_table do
    drop(table(:annacl_performer_annacl_role))
  end

  defp create_performer_permission_table do
    create table(:annacl_performer_annacl_permission) do
      add(:performer_id, references(:annacl_performers, on_delete: :delete_all))
      add(:permission_id, references(:annacl_permissions, on_delete: :delete_all))

      timestamps()
    end

    create(
      unique_index(:annacl_performer_annacl_permission, [:performer_id, :permission_id],
        name: "performer_permission_performer_id_permission_id_index"
      )
    )
  end

  defp drop_performer_permission_table do
    drop(table(:annacl_performer_annacl_permission))
  end
end
