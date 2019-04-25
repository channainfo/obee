defmodule ObeeWeb.Absinthe.VideosTest do
  use ObeeWeb.ConnCase

  test "list_videos with user context" do
    video  = video_fixture()

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

    context =  %{user_id: video.user_id}
    result = Absinthe.run(query, ObeeWeb.Schema, context: context)
    {:ok, %{data: %{ "videos" => videos }}} = result
    video_result = List.first(videos)

    assert video_result["id"] == "#{video.id}"
    assert video_result["title"] == video.title
    assert video_result["description"] == video.description
    assert video_result["url"] == video.url
  end

  test "list_videos without user context" do
    video_fixture()

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

    context =  %{ }
    result = Absinthe.run(query, ObeeWeb.Schema, context: context)
    {:ok, %{ errors: [%{message: message}]}} = result
    assert message == "unauthorized"
  end

  test "paginate_videos(page: page, per_page: per_page)" do
    video_1 = video_fixture(title: "Prison Break Eps1")
    _video_2 = video_fixture(title: "Prison Break Eps2")

    # field :page_number, :integer
    # field :page_size, :integer
    # field :total_pages, :integer
    # field :total_entries, :integer
    # field :entries, list_of(:video)
    query = """
    {
      paginatedVideos(pagination: {page: 1, per_page: 1}) {
        pageNumber
        page_size
        total_pages
        total_entries
        entries {
          id
          title
        }
      }
    }
    """

    context =  %{}
    result = Absinthe.run(query, ObeeWeb.Schema, context: context)
    {:ok, %{ data: %{ "paginatedVideos" => paginate_videos } } } = result

    [%{"id" =>video_id, "title" => video_title}] = paginate_videos["entries"]

    assert length(paginate_videos["entries"]) == 1
    assert video_id == "#{video_1.id}"
    assert video_title == video_title

    assert paginate_videos["pageNumber"] == 1
    assert paginate_videos["page_size"] == 1
    assert paginate_videos["total_entries"] == 2
    assert paginate_videos["total_pages"] == 2

  end

  test "video(id: :id)" do
    video  = video_fixture()
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
