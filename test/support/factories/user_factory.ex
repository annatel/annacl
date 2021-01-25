defmodule Annacl.Factory.User do
  alias Annacl.TestUser

  defmacro __using__(_opts) do
    quote do
      def build(:user) do
        %{id: performer_id} = insert!(:performer)

        %TestUser{
          performer_id: performer_id
        }
      end
    end
  end
end
