defmodule Annacl.Factory.Performer do
  alias Annacl.Performers.{Performer, PerformerPermission, PerformerRole}

  defmacro __using__(_opts) do
    quote do
      def build(:performer) do
        %Performer{}
      end

      def build(:performer_permission) do
        %PerformerPermission{}
      end

      def build(:performer_role) do
        %PerformerRole{}
      end
    end
  end
end
