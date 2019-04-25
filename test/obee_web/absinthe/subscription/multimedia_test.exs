defmodule ObeeWeb.Absinthe.Subscription.MultimediaTest do
  use ObeeWeb.SubscriptionCase

  setup do
    user = user_fixture()
    params = %{
      "token" => user_signed_token(user.id)
    }

    {:ok, socket} = Phoenix.ChannelTest.connect(ObeeWeb.UserSocket, params)
    {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

    {:ok, socket: socket, user: user}
  end

  test "videoAdded subscription", %{socket: socket, user: _} do
    # IO.inspect(String.duplicate("*", 80))
    # IO.inspect(socket.assigns)

    video_subscription = """
      subscription {
        videoAdded {
          id
          title
        }
      }
    """

    ref = push_doc(socket, video_subscription)
    assert_reply(ref, :ok, %{}=subscription)

    title = "Prison Break"
    description  = "Michelle is a structural engineer"
    url = "https://www.test.com"
    category = category_fixture("Action")

    video_mutation = """
      mutation {
        createVideo(title: "#{title}",
                    description: "#{description}",
                    url: "#{url}",
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
    ref = push_doc(socket, video_mutation, socket.assigns)
    assert_reply(ref, :ok, reply)
  end
end
