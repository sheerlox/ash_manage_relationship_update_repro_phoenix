defmodule AshReproWeb.ProfileLive.FormComponent do
  use AshReproWeb, :live_component

  alias AshRepro.Profiles.Profile

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.flash_group flash={@flash} />

      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="profile-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.inputs_for :let={user_form} field={@form[:user]}>
          <.input field={user_form[:firstname]} type="text" label="First name" />
          <.input field={user_form[:lastname]} type="text" label="Last name" />
        </.inputs_for>

        <.input field={@form[:contact_email]} type="text" label="Contact email" />
        <:actions>
          <.button phx-disable-with="Saving...">
            Save Profile
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{profile: profile, action: action} = assigns, socket) do
    form =
      case action do
        :new ->
          AshPhoenix.Form.for_create(Profile, :create, forms: [auto?: true])
          |> AshPhoenix.Form.add_form([:user])

        :edit ->
          AshPhoenix.Form.for_update(profile, :update, forms: [auto?: true])
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(form: to_form(form))}
  end

  @impl true
  def handle_event("validate", %{"form" => profile_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, profile_params))}
  end

  @impl true
  def handle_event("save", %{"form" => profile_params}, socket) do
    IO.inspect(AshPhoenix.Form.params(socket.assigns.form), label: "AshPhoenix.Form.params")

    case AshPhoenix.Form.submit(socket.assigns.form, params: profile_params) do
      {:ok, profile} ->
        # IO.inspect(profile_params, label: "profile_params")
        # IO.inspect(profile, label: "profile")
        notify_parent({:saved, profile})

        message =
          case socket.assigns.action do
            :new -> "Profile created successfully"
            :edit -> "Profile updated successfully"
          end

        {:noreply,
         socket
         |> put_flash(:info, message)
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, form} ->
        errors =
          AshPhoenix.Form.errors(form, format: :plaintext) ++
            AshPhoenix.Form.errors(form, format: :plaintext, for_path: :user)

        {:noreply, socket |> assign(form: form) |> put_flash(:error, List.first(errors, ""))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
