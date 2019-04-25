defmodule ObeeWeb.Resolvers.Multimedia do
  def create_video(_parent, args, %{context: %{ user_id: user_id } } ) do
    user = Obee.Accounts.get_user(user_id)
    {:ok, video } = Obee.Multimedia.create_video(user, args)
    {:ok, video}
  end

  def create_video( _parent , _args, _resolution ) do
    # user = Obee.Accounts.get_user(user_id)
    # {:ok, video } = Obee.Multimedia.create_video(user, args)
    # {:ok, video}
    {:error, :unauthorized}
  end

  def list_videos(_parent, _args, %{context: %{ user_id: _user_id} }) do
    {:ok, Obee.Multimedia.list_videos() }
  end

  def list_videos(_parent, _args, _ ) do
    {:error, :unauthorized }
  end

  def list_paginate_videos(_parent, args, _context) do
    result = paginate_videos(args)
    {:ok, result}
  end

  defp paginate_videos(options) do
    pagination = Map.get(options, :pagination, %{page: 1, per_page: 10 })
    Obee.Repo.paginate(Obee.Multimedia.Video, page: pagination.page, page_size: pagination.per_page)
  end

  def get_video(_parent, %{id: id}, _resolution) do
    {:ok, Obee.Multimedia.get_video!(id)}
  end

  def get_video_category(%Obee.Multimedia.Video{}=video, _arg, _resolution) do
    {:ok, video.category}
  end
end
