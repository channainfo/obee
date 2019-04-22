defmodule ObeeWeb.API.VideosTest do
  use ObeeWeb.ConnCase

  test "list_videos" do
    video  = video_fixture()

    videos = Obee.Multimedia.list_videos()
    assert length(videos) == 1
    # IO.inspect(videos)

    query = """
    {
      videos {
        id
        title
        description
        url
      }
    }
    """

    context =  %{}
    result = Absinthe.run(query, ObeeWeb.Schema, context: context)
    {:ok, %{data: %{ "videos" => videos }}} = result
    video_result = List.first(videos)

    assert video_result["id"] == "#{video.id}"
    assert video_result["title"] == video.title
    assert video_result["description"] == video.description
    assert video_result["url"] == video.url
  end

  test "video(id: :id)" do
    video  = video_fixture()
    # category = Obee.Repo.get(Obee.Multimedia.Category, video.category_id)
    video = Obee.Repo.preload(video, [:category])

    query = """
    {
      video(id: #{video.id}) {
        id
        title
        description
        url
        category {
          id
          name
        }
      }
    }
    """

    context =  %{}
    result = Absinthe.run(query, ObeeWeb.Schema, context: context)
    {:ok, %{ data: %{ "video"=> video_result } } } = result

    assert video_result["id"] == "#{video.id}"
    assert video_result["title"] == video.title
    assert video_result["description"] == video.description
    assert video_result["url"] == video.url
    assert video_result["category"]["id"] == "#{video.category.id}"
    assert video_result["category"]["name"] == video.category.name
  end
end
