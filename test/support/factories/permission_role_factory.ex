defmodule Annacl.Factory.PermissionRole do
  alias Annacl.PermissionsRoles.PermissionRole

  defmacro __using__(_opts) do
    quote do
      def build(:permission_role) do
        %PermissionRole{}
      end
    end
  end
end
