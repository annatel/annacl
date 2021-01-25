defmodule Annacl.Factory.Role do
  alias Annacl.Roles.Role

  defmacro __using__(_opts) do
    quote do
      def build(:role) do
        %Role{
          name: "name_#{System.unique_integer()}"
        }
      end

      def superadmin_role(%Role{} = role), do: %{role | name: Annacl.superadmin_role_name()}
    end
  end
end
