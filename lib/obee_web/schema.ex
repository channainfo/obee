# https://hexdocs.pm/absinthe/schemas.html#content
defmodule ObeeWeb.Schema do
  use Absinthe.Schema

  import_types ObeeWeb.Schema.DateTime
  import_types ObeeWeb.Schema.Multimedia
  import_types ObeeWeb.Schema.Account

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
  end

  mutation do
    @desc "Create a video"
    field(:create_user, :user) do
      arg :first_name, :string
      arg :last_name, :string
      arg :username, :string
      arg :credential, :credential_input


      resolve(&Account.create_user/3)
    end

    # valid_attrs =  %{ first_name: "first_name",
    #                   last_name: "last_name",
    #                   username: "username",
    #                   credential: %{ email: "joe#{System.unique_integer()}@gmail.com",
    #                                  password: "12345678" }
    #               }


  end
end
