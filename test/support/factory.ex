defmodule Annacl.Factory do
  use ExMachina.Ecto, repo: Annacl.TestRepo

  use Annacl.Factory.Permission
  use Annacl.Factory.Role
  use Annacl.Factory.PermissionRole

  use Annacl.Factory.Performer
  use Annacl.Factory.User
end
