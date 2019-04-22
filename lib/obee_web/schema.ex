# https://hexdocs.pm/absinthe/schemas.html#content
defmodule ObeeWeb.Schema do
  use Absinthe.Schema

  import_types ObeeWeb.Schema.DateTime
  import_types ObeeWeb.Schema.Multimedia

  alias ObeeWeb.Resolvers.Multimedia

  query do
    @desc "Get video from its id"
    field :video, :video do
      arg :id, :id
      resolve &Multimedia.get_video/3
    end

    @desc "Get all videos"
    field :videos, list_of(:video) do
      resolve &Multimedia.list_videos/3
      # resolve(fn _,_, _ ->
      #   {:ok, Obee.Multimedia.list_videos() }
      # end)
    end
  end
end
