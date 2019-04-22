defmodule ObeeWeb.Resolvers.Multimedia do
  def list_videos(_parent, _args, _resolution) do
    {:ok, Obee.Multimedia.list_videos() }
  end

  def get_video(_parent, %{id: id}, _resolution) do
    {:ok, Obee.Multimedia.get_video!(id)}
  end

  def get_video_category(%Obee.Multimedia.Video{}=video, _arg, _resolution) do
    {:ok, video.category}
  end
end
