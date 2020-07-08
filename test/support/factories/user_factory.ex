defmodule Annacl.Factory.User do
  alias Annacl.User

  defmacro __using__(_opts) do
    quote do
      def user_factory(attrs) do
        performer_id = Map.get(attrs, :performer_id) || Map.get(insert(:performer), :id)

        user = %User{performer_id: performer_id}

        merge_attributes(user, attrs)
      end
    end
  end
end
