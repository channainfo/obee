defmodule ObeeWeb.Router do
  use ObeeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ObeeWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ObeeWeb do
    pipe_through :browser
    get "/", PageController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete], singleton: true

    get "/watch/:id", WatchController, :show

  end

  scope "/manage", ObeeWeb do
    pipe_through [:browser, :authenticate_user]
    resources "/videos", VideoController
  end

  scope "/cms", ObeeWeb.CMS, as: :cms do
    pipe_through [:browser, :authenticate_user ]
    resources "/pages", PageController
  end


  # Other scopes may use custom stacks.
  # scope "/api", ObeeWeb do
  #   pipe_through :api
  # end


  # defp authenticate_user(conn, _) do
  #   case get_session(conn, :user_id) do
  #     nil ->
  #       conn
  #       |> Phoenix.Controller.put_flash(:error, "Login required")
  #       |> Phoenix.Controller.redirect(to: "/")
  #       |> halt()

  #     user_id ->
  #       assign(conn, :current_user, Obee.Accounts.get_user!(user_id))
  #   end
  # end

end

