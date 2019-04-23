defmodule ObeeWeb.Schema.Pagination do
  use Absinthe.Schema.Notation

  @desc "Pagination Option"
  input_object :pagination do
    field :per_page, :integer, description: "Record per page"
    field :page, :integer, description: "Record at page"
  end
end
