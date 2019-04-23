defmodule ObeeWeb.Absinthe.Mutation.AccountTest do
  use ObeeWeb.ConnCase
  describe "User" do
    test "create a user" do
      first_name = "Sara"
      last_name  = "Tancredi"
      username   = "Sara"
      email      = "saradoc@foxriver.com"
      password   = "sara@foxriver"

      query = """
        mutation {
          createUser(first_name: "#{first_name}",
                    last_name: "#{last_name}",
                    username: "#{username}",
                    credential: {
                      email: "#{email}",
                      password: "#{password}"
                    } )
                  {
                      id
                      first_name
                      last_name
                      username
                    }
        }


      """
      result = Absinthe.run(query, ObeeWeb.Schema, context: %{})
      {:ok, %{data:  %{ "createUser" => user }  } } = result

      assert user["first_name"] == "Sara"
      assert user["last_name"] == "Tancredi"
      assert user["username"] == "Sara"
      assert is_nil(user["id"]) == false

    end

    test "authenticate user" do
      valid_attrs =  %{ first_name: "some first_name",
                        last_name: "some last_name",
                        username: "some username",
                        credential: %{ email: "joe@gmail.com",
                                       password: "hellobroker"
                                    }
                      }
      user_fixture(valid_attrs)

      email = valid_attrs[:credential][:email]
      password = valid_attrs[:credential][:password]

      query = """
        mutation {
          authenticate(
                      email: "#{email}",
                      password: "#{password}"
                    )
        }
      """
      context = %{}
      result = Absinthe.run(query, ObeeWeb.Schema, context: context)
      {:ok, %{data: %{"authenticate" => token } } } = result
      assert byte_size(token) != 0
    end
  end
end

