defmodule ObeeWeb.VideoControllerTest do
  use ObeeWeb.ConnCase

  @create_attrs %{description: "some description",
                  title: "charlie",
                  url: "https://www.youtube.com/watch?v=_OBlgSz8sSM",
                  file: file_upload_fixture("charlie_bit_my_finger.mp4") }
  @update_attrs %{description: "some updated description",
                  title: "new charlie",
                  url: "https://www.youtube.com/watch?v=mU8RDfWJQ-A" }

  @invalid_attrs %{description: nil, title: nil, url: nil}

  test "requires authentication for all actions", %{conn: conn} do
    Enum.each([
      get(conn, Routes.video_path(conn, :new)),
      post(conn, Routes.video_path(conn, :create, %{})),
      get(conn, Routes.video_path(conn, :edit, "100")),
      put(conn, Routes.video_path(conn, :update, "100", %{})),
      get(conn, Routes.video_path(conn, :index)),
      delete(conn, Routes.video_path(conn, :delete, "100")),
      get(conn, Routes.video_path(conn, :show, "100")),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  test "authorizes action against resource owner", %{conn: conn} do
    owner = user_fixture(username: "mrfoo")
    owner_video = user_video_fixture(owner, title: "Prison Break Eps1")

    other_user = user_fixture(username: "mrother")

    conn = assign(conn, :current_user, other_user)

    assert_error_sent :not_found, fn ->
      get(conn, Routes.video_path(conn, :show, owner_video))
    end

    assert_error_sent :not_found, fn ->
      get(conn, Routes.video_path(conn, :edit, owner_video))
    end

    assert_error_sent :not_found, fn ->
      put(conn, Routes.video_path(conn, :update, owner_video, video: @update_attrs))
    end

    assert_error_sent :not_found, fn ->
      delete(conn, Routes.video_path(conn, :delete, owner_video))
    end
  end

  describe "with user logged in" do
    setup %{conn: conn} do
      user = user_fixture(username: "mrfoo")
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    end

    test "GET/index: lists all user's videos", %{conn: conn, user: user} do
      user_video = user_video_fixture(user, title: "Prison Break Eps1")
      other_video = video_fixture()

      conn = get(conn, Routes.video_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Videos"
      assert String.contains?(conn.resp_body, user_video.title)
      refute String.contains?(conn.resp_body, other_video.title)
    end

    test "GET/new: renders form", %{conn: conn} do
      conn = get(conn, Routes.video_path(conn, :new))
      assert html_response(conn, 200) =~ "New Video"
    end

    test "POST/create: create record and redirect to show when data is valid", %{conn: conn, user: user} do
      conn = post(conn, Routes.video_path(conn, :create), video: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.video_path(conn, :show, id)

      video = Obee.Multimedia.get_user_video!(user, id)
      assert video.url == "#{user.id}-charlie_bit_my_finger.mp4"

      # conn = get(conn, Routes.video_path(conn, :show, id))
      # assert html_response(conn, 200) =~ "Show Video"
    end

    test "POST/create: renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.video_path(conn, :create), video: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Video"
    end

    test "GET/edit: renders form for editing chosen video", %{conn: conn, user: user} do
      user_video = user_video_fixture(user, title: "Prison Break Eps1")
      conn = get(conn, Routes.video_path(conn, :edit, user_video))
      assert html_response(conn, 200) =~ "Edit Video"
    end

    test "PUT/update: redirects when data is valid", %{conn: conn, user: user} do
      user_video = user_video_fixture(user, title: "Prison Break Eps1")
      conn = put(conn, Routes.video_path(conn, :update, user_video), video: @update_attrs)
      video = Obee.Multimedia.get_video!(user_video.id)
      assert redirected_to(conn) == Routes.video_path(conn, :show, video)

      # conn = get(conn, Routes.video_path(conn, :show, video))
      # assert html_response(conn, 200) =~ "some updated title"
    end

    test "PUT/update: renders errors when data is invalid", %{conn: conn, user: user} do
      user_video = user_video_fixture(user, title: "Prison Break Eps1")
      conn = put(conn, Routes.video_path(conn, :update, user_video), video: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Video"
    end

    test "DELETE/delete: delete chosen video", %{conn: conn, user: user} do
      user_video = user_video_fixture(user, title: "Prison Break Eps1")
      conn = delete(conn, Routes.video_path(conn, :delete, user_video))
      assert redirected_to(conn) == Routes.video_path(conn, :index)
      # assert_error_sent 404, fn ->
      #   get(conn, Routes.video_path(conn, :show, user_video))
      # end
    end
  end
end
