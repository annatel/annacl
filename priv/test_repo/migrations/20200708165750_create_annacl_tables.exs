defmodule Annacl.TestRepo.Migrations.CreateAnnaclTables do
  use Ecto.Migration

  def up do
    Annacl.Migrations.V1.up()
  end

  def down do
    Annacl.Migrations.V1.down()
  end
end
