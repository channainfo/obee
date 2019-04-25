# https://hexdocs.pm/absinthe/schemas.html#content
defmodule ObeeWeb.Schema do
  use Absinthe.Schema

  import_types ObeeWeb.Schema.DateTime
  import_types ObeeWeb.Schema.Multimedia
  import_types ObeeWeb.Schema.Account
  import_types ObeeWeb.Schema.PaginatedVideos
  import_types ObeeWeb.Schema.Pagination

  alias ObeeWeb.Resolvers.Multimedia
  alias ObeeWeb.Resolvers.Account

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

    @desc "Get paginate videos"
    field :paginated_videos, :paginated_videos do
      arg :pagination, :pagination, description: "Pagination params"
      resolve &Multimedia.list_paginate_videos/3
      # resolve(fn _,_, _ ->
      #   {:ok, Obee.Multimedia.list_videos() }
      # end)
    end
  end

  mutation do
    @desc "Create a user"
    field(:create_user, :user) do
      arg :first_name, :string
      arg :last_name, :string
      arg :username, :string
      arg :credential, :credential_input

      resolve(&Account.create_user/3)
    end

    @desc "Create a video"
    field(:create_video, :video) do
      arg :title, :string
      arg :description, :string
      arg :url, :string
      arg :category_id, :integer

      resolve(&Multimedia.create_video/3)
    end

    @desc "Authenticate user with email and password"
    field(:authenticate, :string) do
      arg :email, :string, description: "Credential email"
      arg :password, :string, description: "Credential password"

      resolve(&Account.authenticate/3)
    end
  end

  subscription do
    @desc "Get notified when a video added"
    field(:video_added, :video) do
      config( fn(_args, _resolution) ->
        {:ok, topic: :global}
      end)

      trigger(:create_video, topic: fn( _video ) ->
        :global
      end)
    end
  end
end
