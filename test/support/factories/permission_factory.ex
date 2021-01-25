defmodule Annacl.Factory.Permission do
  alias Annacl.Permissions.Permission

  defmacro __using__(_opts) do
    quote do
      def build(:permission) do
        %Permission{
          name: "name_#{System.unique_integer()}"
        }
      end
    end
  end
end
