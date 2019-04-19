defmodule ObeeWeb.CMS.PageControllerTest do
  use ObeeWeb.ConnCase

  @create_attrs %{body: "some body", title: "some title", views: 42}
  @update_attrs %{body: "some updated body", title: "some updated title", views: 43}
  @invalid_attrs %{body: nil, title: nil, views: nil}

  test "requires authentication for all actions", %{conn: conn} do
    Enum.each([
      get(conn, Routes.user_path(conn, :new)),
      post(conn, Routes.user_path(conn, :create)),
      get(conn, Routes.user_path(conn, :edit, "100")),
      put(conn, Routes.user_path(conn, :update, "100")),
      get(conn, Routes.user_path(conn, :index)),
      delete(conn, Routes.user_path(conn, :delete, "100")),
      get(conn, Routes.user_path(conn, :show, "100")),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  describe "With authenticated user" do
     # setup [:create_user]
    setup %{conn: conn} do
      page = page_fixture()
      page = Obee.CMS.get_page!(page.id)
      user = page.author.user
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user, page: page}
    end

    test "GET/index: lists all pages", %{conn: conn} do
      conn = get(conn, Routes.cms_page_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Pages"
    end

    test "GET/new: renders form", %{conn: conn} do
      conn = get(conn, Routes.cms_page_path(conn, :new))
      assert html_response(conn, 200) =~ "New Page"
    end

    test "POST/create: redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.cms_page_path(conn, :create), page: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.cms_page_path(conn, :show, id)

      # conn = get(conn, Routes.cms_page_path(conn, :show, id))
      # assert html_response(conn, 200) =~ "Show Page"
    end

    test "POST/create: renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.cms_page_path(conn, :create), page: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Page"
    end

    test "GET/edit: renders form for editing chosen page", %{conn: conn, page: page} do
      conn = get(conn, Routes.cms_page_path(conn, :edit, page))
      assert html_response(conn, 200) =~ "Edit Page"
    end

    test "PUT/update: redirects when data is valid", %{conn: conn, page: page} do
      conn = put(conn, Routes.cms_page_path(conn, :update, page), page: @update_attrs)
      assert redirected_to(conn) == Routes.cms_page_path(conn, :show, page)

      # conn = get(conn, Routes.cms_page_path(conn, :show, page))
      # assert html_response(conn, 200) =~ "some updated body"
    end

    test "PUT/update: renders errors when data is invalid", %{conn: conn, page: page} do
      conn = put(conn, Routes.cms_page_path(conn, :update, page), page: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Page"
    end

    test "DELETE/delete: deletes chosen page", %{conn: conn, page: page} do
      conn = delete(conn, Routes.cms_page_path(conn, :delete, page))
      assert redirected_to(conn) == Routes.cms_page_path(conn, :index)
      # assert_error_sent 404, fn ->
      #   get(conn, Routes.cms_page_path(conn, :show, page))
      # end
    end
  end

end
