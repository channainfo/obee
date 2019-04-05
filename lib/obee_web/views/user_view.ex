defmodule ObeeWeb.UserView do
  use ObeeWeb, :view

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.username}
  end
end
