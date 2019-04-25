defmodule ObeeWeb.Absinthe.Mutation.MultimediaTest do
  use ObeeWeb.ConnCase
  describe "Video" do
    test "create a video" do
      title = "Prison Break"
      description  = "Michelle is a structural engineer"
      category = category_fixture("Action")

      query = """
        mutation {
          createVideo(title: "#{title}",
                      description: "#{description}",
                      url: "https://www.test.com",
                      category_id: #{category.id}
                    )
          {
            id
            title
            description
            url
            category{
              id
              name
            }
          }
        }
      """
      user = user_fixture()

      context = %{user_id: user.id}
      result = Absinthe.run(query, ObeeWeb.Schema, context: context)
      {:ok, %{ data: %{ "createVideo" => video_result } } } = result

      assert video_result["title"] == "Prison Break"
      assert video_result["description"] == "Michelle is a structural engineer"
      assert video_result["category"] == %{"id" => "#{category.id}", "name" => "#{category.name}"}
    end
  end
end

