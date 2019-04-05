defmodule ObeeWeb.AnnotationView do
  use ObeeWeb, :view

  def render("annotation.json", %{annotation: annotation}) do
    %{ id: annotation.id,
      body: annotation.body,
      at: annotation.at,
      user: render_one(annotation.user, ObeeWeb.UserView, "user.json")
    }
  end
end
