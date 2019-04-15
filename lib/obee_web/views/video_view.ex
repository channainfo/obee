defmodule ObeeWeb.VideoView do
  use ObeeWeb, :view

  def category_select_options(categories) do
    for category <- categories do
      {category.name, category.id}
    end
  end


  def category_name(category) when is_nil(category) do
    ""
  end

  def category_name(category) do
    category.name
  end

end
