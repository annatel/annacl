defmodule Annacl.TestRepo do
  use Ecto.Repo,
    otp_app: :annacl,
    adapter: Ecto.Adapters.MyXQL
end
