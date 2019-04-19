defmodule ObeeWeb.UserControllerTest do
  use ObeeWeb.ConnCase

  @create_attrs %{first_name: "some first_name",
                  last_name: "some last_name",
                  username: "some username",
                  credential: %{ email: "joe#{System.unique_integer()}@gmail.com", password: "12345678" }
                }

  @update_attrs %{first_name: "some updated first_name",
                  last_name: "some updated last_name",
                  username: "some updated username",
                  credential: %{ email: "joe#{System.unique_integer()}@gmail.com", password: "12345678" }
                }

  @invalid_attrs %{first_name: nil, last_name: nil, username: nil}

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
      user = user_fixture(username: "mrfoo")
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    end

    test "GET/index: lists all users", %{conn: conn } do
      conn = get(conn, Routes.user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Users"
    end

    test "GET/new: renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_path(conn, :show, id)

      conn = get(conn, Routes.user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User"
    end

    test "POST/create: renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end

    test "redirects when data is valid", %{conn: conn, user: user} do
      credential = %{
        email: "updated@gmail.com",
        id: user.credential.id,
        password: "12345687"
      }

      attrs = Map.put(@update_attrs, :credential, credential)

      conn = put(conn, Routes.user_path(conn, :update, user), user: attrs)
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)

      # conn = get(conn, Routes.user_path(conn, :show, user))
      # assert html_response(conn, 200) =~ "some updated first_name"
    end

    test "PUT/update: renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end

    test "DELET/delete: deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.user_path(conn, :index)
      # assert_error_sent 404, fn ->
      #   get(conn, Routes.user_path(conn, :show, user))
      # end
    end
  end
end
