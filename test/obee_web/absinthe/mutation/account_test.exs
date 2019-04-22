defmodule ObeeWeb.Absinthe.Mutation.AccountTest do
  use ObeeWeb.ConnCase

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
end
