defmodule AshReproWeb.ProfileLive.Index do
  use AshReproWeb, :live_view

  alias AshRepro.Profiles
  alias AshRepro.Profiles.Profile

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :profiles, Profiles.read!(Profile, load: [:user]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Profile")
    |> assign(:profile, Profiles.get!(Profile, id, load: [:user]))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Profile")
    |> assign(:profile, %Profile{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Profiles")
    |> assign(:profile, nil)
  end

  @impl true
  def handle_info({AshReproWeb.ProfileLive.FormComponent, {:saved, profile}}, socket) do
    {:noreply, stream_insert(socket, :profiles, profile)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    profile = Profiles.get!(Profile, id)
    {:ok, _} = Profiles.delete_profile_and_user(profile)

    {:noreply, stream_delete(socket, :profiles, profile)}
  end
end
