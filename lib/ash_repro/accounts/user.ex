defmodule AshRepro.Accounts.User do
  use Ash.Resource,
    api: AshRepro.Accounts,
    data_layer: AshPostgres.DataLayer

  postgres do
    repo AshRepro.Repo
    table "users"
  end

  attributes do
    integer_primary_key :id

    attribute :firstname, :string, allow_nil?: false
    attribute :lastname, :string, allow_nil?: false

    attribute :created_from_profile, :boolean, default: false

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  actions do
    defaults([:read, :destroy])

    create :create_from_profile do
      change set_attribute(:created_from_profile, true)
    end

    update :update_from_profile do
      reject [:created_from_profile]

      # change(fn changeset, _context ->
      #   IO.inspect(changeset, label: "USER CHANGESET")
      # end)
    end
  end
end
