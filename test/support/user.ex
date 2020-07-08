defmodule Annacl.User do
  use Ecto.Schema

  alias Annacl.ACL.Performers.Performer

  embedded_schema do
    belongs_to(:performer, Performer)
  end
end
