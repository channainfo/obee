defmodule ObeeWeb.CMS.PageView do
  use ObeeWeb, :view

  alias Obee.CMS

  def author_name(%CMS.Page{author: author}) do
    gettext "%{first_name} %{last_name}", first_name: author.user.first_name,
                                          last_name: author.user.last_name
  end
end
