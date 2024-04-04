defmodule AshRepro.Accounts do
  use Ash.Api

  resources do
    resource AshRepro.Accounts.User
  end
end
