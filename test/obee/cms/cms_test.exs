defmodule Obee.CMSTest do
  use Obee.DataCase

  alias Obee.CMS

  describe "pages" do
    alias Obee.CMS.Page

    # @valid_attrs %{body: "some body", title: "some title", views: 42}
    @update_attrs %{body: "some updated body", title: "some updated title", views: 43}
    @invalid_attrs %{body: nil, title: nil, views: nil}


    test "list_pages/0 returns all pages" do
      page = page_fixture()
      assert CMS.list_pages() |> length()  == 1
      [first | _ ] = CMS.list_pages()
      assert first.title == page.title
      assert first.body == page.body
    end

    test "get_page!/1 returns the page with given id" do
      page = page_fixture()
      assert CMS.get_page!(page.id).id == page.id
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_page(%CMS.Author{} ,@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = page_fixture()
      assert {:ok, %Page{} = page} = CMS.update_page(page, @update_attrs)
      assert page.body == "some updated body"
      assert page.title == "some updated title"
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = page_fixture()
      assert {:error, %Ecto.Changeset{}} = CMS.update_page(page, @invalid_attrs)

    end

    test "delete_page/1 deletes the page" do
      page = page_fixture()
      assert {:ok, %Page{}} = CMS.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_page!(page.id) end
    end

    test "change_page/1 returns a page changeset" do
      page = page_fixture()
      assert %Ecto.Changeset{} = CMS.change_page(page)
    end
  end

end
