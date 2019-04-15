defmodule Obee.AccountsTest do
  use Obee.DataCase

  alias Obee.Accounts

  describe "users" do
    alias Obee.Accounts.User

    @valid_attrs %{ first_name: "some first_name",
                    last_name: "some last_name",
                    username: "some username",
                    credential: %{ email: "joe@gmail.com", password: "12345678" }
                  }

    @update_attrs %{ first_name: "some updated first_name",
                     last_name: "some updated last_name",
                     username: "some updated username",
                     credential: %{ email: "foo@gmail.com", password: "12345678"}
                  }


    @invalid_attrs %{first_name: nil, last_name: nil, username: nil}



    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.username == "some username"
      assert user.credential.email == "joe@gmail.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      old_user = user_fixture()
      # old_user = Accounts.get_user!(user.id)

      credential = %{
        email: "updated@gmail.com",
        id: old_user.credential.id,
        password: "12345687"
      }

      attrs = Map.put(@update_attrs, :credential, credential)

      # IO.inspect(" new attrs -------------------")
      # IO.inspect(attrs)

      # case Accounts.update_user(old_user, attrs) do
      #   {:ok, user} ->
      #     IO.inspect("update successully")
      #     IO.inspect(user)
      #   {:error, error} ->
      #     IO.inspect("fail to update")
      #     IO.inspect(error)
      # end

      assert {:ok, %User{} = user} = Accounts.update_user(old_user, attrs)
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.username == "some updated username"
      assert user.credential.email == "updated@gmail.com"
      assert user.id == old_user.id
      assert user.credential.id == old_user.credential.id
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

end
