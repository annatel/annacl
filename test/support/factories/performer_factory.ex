defmodule Annacl.Factory.Performer do
  alias Annacl.Performers.{Performer, PerformerPermission, PerformerRole}

  defmacro __using__(_opts) do
    quote do
      def performer_factory do
        %Performer{}
      end

      def performer_permission_factory do
        %PerformerPermission{}
      end

      def performer_role_factory do
        %PerformerRole{}
      end
    end
  end
end
