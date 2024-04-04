defmodule AshRepro.Profiles.Profile do
  use Ash.Resource,
    api: AshRepro.Profiles,
    data_layer: AshPostgres.DataLayer

  postgres do
    repo AshRepro.Repo
    table "profiles"
  end

  attributes do
    integer_primary_key :id

    attribute :contact_email, :string, allow_nil?: false

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :user, AshRepro.Accounts.User do
      api AshRepro.Accounts
      attribute_type :integer
    end
  end

  actions do
    defaults [:read]

    create :create do
      primary? true

      argument :user, :map do
        allow_nil? false
      end

      change manage_relationship(:user,
               on_no_match: {:create, :create_from_profile},
               on_match: :error,
               on_missing: :error
             )
    end

    update :update do
      primary? true

      argument :user, :map do
        allow_nil? false
      end

      change manage_relationship(:user,
               on_match: {:update, :update_from_profile},
               on_no_match: :error,
               on_missing: :error
             )

      # change(fn changeset, _context ->
      #   IO.inspect(changeset, label: "PROFILE CHANGESET")
      # end)
    end
  end
end
