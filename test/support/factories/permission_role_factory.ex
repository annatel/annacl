defmodule Annacl.Factory.PermissionRole do
  alias Annacl.ACL.PermissionsRoles.PermissionRole

  defmacro __using__(_opts) do
    quote do
      def permission_role_factory do
        %PermissionRole{}
      end
    end
  end
end
