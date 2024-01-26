defmodule MyPjt1Web.UserSettingsLive do
  use MyPjt1Web, :live_view
  require Logger

  alias MyPjt1.Accounts

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Account Settings
    </.header>

    <div class="space-y-12 divide-y">
      <div>
        <.simple_form
          for={@nickname_form}
          id="nickname_form"
          phx-submit="update_nickname"
        >
          <.input field={@nickname_form[:nickname]} label="Nickname" required />
          <%!-- <.input
            field={@nickname_form[:current_password]}
            name="current_password"
            id="current_password_for_nickname"
            type="password"
            label="Current password"
            required
          /> --%>
          <:actions>
            <.button phx-disable-with="Changing...">Change Nickname</.button>
          </:actions>
        </.simple_form>
      </div>
      <div>
        <.simple_form
          for={@password_form}
          id="password_form"
          action={~p"/users/log_in?_action=password_updated"}
          method="post"
          phx-change="validate_password"
          phx-submit="update_password"
          phx-trigger-action={@trigger_submit}
        >
          <.input
            field={@password_form[:email]}
            type="hidden"
            id="hidden_user_email"
            value={@current_email}
          />
          <.input field={@password_form[:password]} type="password" label="New password" required />
          <.input
            field={@password_form[:password_confirmation]}
            type="password"
            label="Confirm new password"
          />
          <.input
            field={@password_form[:current_password]}
            name="current_password"
            type="password"
            label="Current password"
            id="current_password_for_password"
            value={@current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Password</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    password_changeset = Accounts.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:nickname_form, to_form(%{"nickname" => socket.assigns.current_user.nickname, "current_password" => nil}))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("update_nickname", %{"nickname" => nickname}, socket) do
    IO.inspect(socket.assigns.current_user, label: "zzzz")

    case Accounts.update_nickname(socket.assigns.current_user, %{"email" => socket.assigns.current_user.email, "nickname" => nickname}) do
      {:ok, user} ->
        notify_parent({:saved, user})
        Logger.info("success???????")

        {:noreply,
          socket
          |> put_flash(:info, "User infomation updated successfully")
          |> push_navigate(to: "/")
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.info("fail???????")
        {:noreply, assign_form(socket, changeset)}
    end

  end


  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end


  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
