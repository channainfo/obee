defmodule ObeeWeb.VideoController do
  use ObeeWeb, :controller

  alias Obee.Multimedia
  alias Obee.Multimedia.Video

  plug :load_categories when action in [:new, :create, :edit, :update]

  def index(conn, _params, current_user) do
    videos = Multimedia.list_user_videos(current_user)
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params, current_user) do
    changeset = Multimedia.change_video(current_user, %Video{})
    render(conn, "new.html", changeset: changeset)
  end

  @spec create(Plug.Conn.t(), map(), Obee.Accounts.User.t()) :: Plug.Conn.t()
  def create(conn, %{"video" => video_params}, current_user) do
    case Multimedia.create_video(current_user, video_params ) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: Routes.video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    video = Multimedia.get_user_video!(current_user, id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, current_user) do
    video = Multimedia.get_user_video!(current_user, id)
    changeset = Multimedia.change_video(current_user, video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, current_user) do
    video = Multimedia.get_user_video!(current_user, id)
    case Multimedia.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: Routes.video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    video = Multimedia.get_user_video!(current_user, id)
    {:ok, _video} = Multimedia.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: Routes.video_path(conn, :index))
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  defp load_categories(conn, _) do
    assign(conn, :categories, Multimedia.list_alphabetical_categories())
  end

  # def set_attrs_with_url(video_params, current_user) do
  #   url = case upload = video_params["file"] do
  #     %Plug.Upload{} ->
  #       # extension = Path.extname(upload.filename)
  #       file_name = "#{current_user.id}-#{upload.filename}"
  #       location = "media/#{file_name}"
  #       File.cp!(upload.path, location)
  #       file_name
  #     _ ->
  #       video_params["url"]
  #   end

  #   Map.put(video_params, "url", url)
  # end

end
