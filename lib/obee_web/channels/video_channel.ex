defmodule ObeeWeb.VideoChannel do
  use ObeeWeb, :channel

  alias Obee.Accounts
  alias Obee.Multimedia

  def join("videos:" <> video_id, params, socket) do
    last_seen_id = params["last_seen_id"] || 0

    video_id = String.to_integer(video_id)
    video = Multimedia.get_video!(video_id)

    annotations =
      video
      |> Multimedia.list_annotations(last_seen_id)
      |> Phoenix.View.render_many(ObeeWeb.AnnotationView, "annotation.json")

    # :timer.send_interval(5_000, :ping)

    # {:ok, socket}

    { :ok, %{annotations: annotations}, assign(socket, :video_id, video_id)}
  end

  def handle_in(event, params, socket) do
    user = Accounts.get_user!(socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do

    case Multimedia.annotate_video(user, socket.assigns.video_id, params) do
      {:ok, annotation } ->
        broadcast!(socket, "new_annotation", %{
          id: annotation.id,
          user: ObeeWeb.UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at
        })
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}

    end


  end

  def handle_info(:ping, socket) do
    count = socket.assigns[:count] || 1
    push(socket, "ping", %{count: count})

    IO.puts("Channel ping: #{count + 1}")
    {:noreply, assign(socket, :count, count + 1)}
  end

end
