defmodule ObeeWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias ObeeWeb.Router.Helpers, as: Routes
  alias Obee.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Accounts.get_user(user_id)
    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def login_by_email_and_pass(conn, email, given_pass) do
    IO.inspect("email: #{email}, pawd: #{given_pass}")
    result = Accounts.authenticate_by_email_and_pass(email, given_pass)
    IO.inspect(result)
    case result do
      {:ok, user} -> {:ok, login(conn, user)}
      {:error, :unauthorized} -> {:error, :unauthorized, conn}
      {error, :not_found} -> {:error, :not_found, conn}
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
