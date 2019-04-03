defmodule ObeeWeb.SessionController do
  use ObeeWeb, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{ "user" => %{ "email" => email, "password" => password } }) do
    case ObeeWeb.Auth.login_by_email_and_pass(conn, email, password) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Incorrect email/password combination")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> ObeeWeb.Auth.logout()
    |> redirect(to: Routes.session_path(conn, :new))
  end


end
