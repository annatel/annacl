{:ok, _pid} = Annacl.TestRepo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(Annacl.TestRepo, :manual)

ExUnit.start()
