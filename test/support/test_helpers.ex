defmodule Obee.TestHelpers do
  alias Obee.{ Accounts, Multimedia, CMS }
  alias Obee.Repo

  # def user_fixture(attrs \\ %{}) do
  #   username = "user#{System.unique_integer([:positive])}"

  #   {:ok, user } =
  #     attrs
  #       |> Enum.into(%{
  #         first_name: "FName",
  #         last_name: "LName",
  #         username: username,
  #         credential: %{
  #           email: attrs[:email] || "#{username}@obee.com",
  #           password: attrs[:password] || "password-sg"
  #         }
  #       })
  #       |> Accounts.register_user()
  #   user
  # end

  def user_fixture(attrs \\ %{}) do
    valid_attrs =  %{ first_name: "first_name",
                      last_name: "last_name",
                      username: "username",
                      credential: %{ email: "joe#{System.unique_integer()}@gmail.com",
                                     password: "12345678" }
                  }

    {:ok, user} =
      attrs
      |> Enum.into(valid_attrs)
      |> Accounts.create_user()
    user
  end

  def author_fixture(attrs \\ %{}) do
    user = user_fixture()
    author_attrs = %{ bio: "some updated bio",
                      genre: "some updated genre",
                      role: "some updated role"
                    }
    author_attrs = attrs |> Enum.into(author_attrs)

    result =  %CMS.Author{}
              |> CMS.Author.changeset(author_attrs)
              |> Ecto.Changeset.put_assoc(:user, user)
              |> Repo.insert()

    {:ok, author} = result
    author
  end

  def page_fixture(attrs \\ %{}) do
    author = author_fixture()

    valid_attrs = %{
      body: "some body",
      title: "some title",
      views: 42,
    }

    result =
      author
      |> CMS.create_page(Enum.into(attrs, valid_attrs))
    {:ok, page } = result
    page
  end

  def category_fixture(name \\ "") do
    name = case name do
      "" ->
        "Category#{System.unique_integer()}"
      _ ->
        name
    end
    Multimedia.create_category(name)
  end

  def video_fixture( attrs \\ %{} ) do
    user = user_fixture()
    category = category_fixture()

    attrs =
      Enum.into(attrs, %{
        title: "Prison Break #{System.unique_integer()}",
        url: "https://prisonbreak.com",
        description: "Prison Break Fox movie",
        category_id: category.id
      })
      {:ok, video} = Multimedia.create_video(user, attrs)

    video
  end

  def user_video_fixture(user, attrs \\ %{} ) do
    attrs =
    Enum.into(attrs, %{
      title: "Prison Break #{System.unique_integer()}",
      url: "https://prisonbreak.com",
      description: "Prison Break Fox movie"
    })

    {:ok, video} = Multimedia.create_video(user, attrs)

    video
  end

  def file_upload_fixture(filename \\ "default.png") do
    root = File.cwd!
    path = "#{root}/test/support/data/#{filename}"
    %Plug.Upload{path: path, filename: filename}
  end
end
