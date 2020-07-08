defmodule Annacl.Factory.Permission do
  alias Annacl.ACL.Permissions.Permission

  defmacro __using__(_opts) do
    quote do
      def permission_factory do
        %Permission{
          name: sequence("name_")
        }
      end
    end
  end
end
