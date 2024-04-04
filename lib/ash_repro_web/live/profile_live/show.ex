defmodule AshReproWeb.ProfileLive.Show do
  use AshReproWeb, :live_view

  alias AshRepro.Profiles
  alias AshRepro.Profiles.Profile

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    profile = Profiles.get!(Profile, id, load: [:user])

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action, profile))
     |> assign(:profile, profile)}
  end

  defp page_title(:show, profile), do: "Profile - #{profile_name(profile)}"

  defp page_title(:edit, profile),
    do: "Edit Profile" <> " - #{profile_name(profile)}"

  defp profile_name(profile), do: "#{profile.user.firstname} #{profile.user.lastname}"
end
