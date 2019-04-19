defmodule ObeeWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias ObeeWeb.Router.Helpers, as: Routes
  alias Obee.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        put_current_user(conn, user)

      user = user_id && Accounts.get_user(user_id) ->
        put_current_user(conn, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> put_current_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def put_current_user(conn, user) do
    token = Phoenix.Token.sign(conn, "user_socket_salt", user.id)
    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end

  def login_by_email_and_pass(conn, email, given_pass) do
    result = Accounts.authenticate_by_email_and_pass(email, given_pass)
    case result do
      {:ok, user} -> {:ok, login(conn, user)}
      {:error, :unauthorized} -> {:error, :unauthorized, conn}
      {:error, :not_found} -> {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  # plug contracts have 2 vars conn and opts
  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be loggin in to access hat pag")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()

    end
  end
end
