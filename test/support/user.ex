defmodule Annacl.TestUser do
  use Ecto.Schema

  alias Annacl.Performers.Performer

  embedded_schema do
    belongs_to(:performer, Performer)
  end
end
