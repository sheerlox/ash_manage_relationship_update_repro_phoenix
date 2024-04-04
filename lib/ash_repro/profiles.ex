defmodule AshRepro.Profiles do
  use Ash.Api

  import Ecto.Query, warn: false

  alias AshRepro.Repo
  alias AshRepro.Profiles.Profile
  alias AshRepro.Accounts

  resources do
    resource(AshRepro.Profiles.Profile)
  end

  @doc """
  Deletes a profile and the underlying user.

  """
  def delete_profile_and_user(%Profile{} = profile) do
    result =
      Ecto.Multi.new()
      |> Ecto.Multi.delete(
        :profile,
        profile
      )
      |> Ecto.Multi.delete_all(
        :user,
        from(u in Accounts.User, where: u.id == ^profile.user_id)
      )
      |> Repo.transaction()

    case result do
      {:error, _, changeset, _} ->
        {:error, changeset}

      {:ok, %{profile: profile}} ->
        {:ok, profile}
    end
  end
end
