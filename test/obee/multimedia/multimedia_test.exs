defmodule Obee.MultimediaTest do
  use Obee.DataCase

  alias Obee.Multimedia

  describe "videos" do
    alias Obee.Multimedia.Video

    @create_attrs %{description: "charlie description",
                    title: "charlie",
                    url: "https://www.youtube.com/watch?v=_OBlgSz8sSM",
                    file: file_upload_fixture("charlie_bit_my_finger.mp4") }

    @update_attrs %{description: "charlie updated description",
                    title: "charlie updated title",
                    url: "https://www.youtube.com/watch?v=mU8RDfWJQ-A",
                    file: file_upload_fixture("default.png")  }

    @invalid_attrs %{description: nil,
                     title: nil,
                     url: nil}

    test "list_videos/0 returns all videos" do
      video_fixture()
      assert length(Multimedia.list_videos()) == 1
    end

    test "get_video!/1 returns the video with given id" do
      video = video_fixture()
      assert Multimedia.get_video!(video.id).id == video.id
    end

    test "create_video/1 with valid data  without file upload creates a video" do
      user = user_fixture()
      attrs = Map.take(@create_attrs, [:title, :description, :url])
      assert {:ok, %Video{} = video} = Multimedia.create_video(user, attrs)
      assert video.description == "charlie description"
      assert video.title == "charlie"
      assert video.url == "https://www.youtube.com/watch?v=_OBlgSz8sSM"
    end

    test "create_video/1 with valid data with file upload creates a video" do
      user = user_fixture()
      assert {:ok, %Video{} = video} = Multimedia.create_video(user, @create_attrs)
      assert video.description == "charlie description"
      assert video.title == "charlie"
      assert video.url == "#{user.id}-charlie_bit_my_finger.mp4"
    end

    test "create_video/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_video(user,@invalid_attrs)
    end

    test "update_video/2 with valid data and new file upload updates the video" do
      user = user_fixture()
      video = user_video_fixture(user)
      assert {:ok, %Video{} = video} = Multimedia.update_video(video, @update_attrs)
      assert video.description == "charlie updated description"
      assert video.title == "charlie updated title"
      assert video.url == "#{user.id}-default.png"
    end

    test "update_video/2 with valid data and without upload updates the video" do
      user = user_fixture()
      video = user_video_fixture(user)
      attrs = Map.take(@update_attrs, [:title, :url, :description] )

      assert {:ok, %Video{} = video} = Multimedia.update_video(video, attrs)
      assert video.description == "charlie updated description"
      assert video.title == "charlie updated title"
      assert video.url == "https://www.youtube.com/watch?v=mU8RDfWJQ-A"
    end

    test "update_video/2 with invalid data returns error changeset" do
      user = user_fixture()
      video = user_video_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Multimedia.update_video(video, @invalid_attrs)
      assert video.id == Multimedia.get_video!(video.id).id
    end

    test "delete_video/1 deletes the video" do
      user = user_fixture()
      video = user_video_fixture(user)
      assert {:ok, %Video{}} = Multimedia.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Multimedia.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset" do
      user = user_fixture()
      video = user_video_fixture(user)
      assert %Ecto.Changeset{} = Multimedia.change_video(video.user, video)
    end
  end
end
