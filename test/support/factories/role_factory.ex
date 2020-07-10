defmodule Annacl.Factory.Role do
  alias Annacl.Roles.Role

  defmacro __using__(_opts) do
    quote do
      def role_factory do
        %Role{
          name: sequence("name_")
        }
      end

      def role_superadmin(api_key) do
        %{api_key | name: "superadmin"}
      end
    end
  end
end
