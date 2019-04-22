defmodule ObeeWeb.Schema.Multimedia do
  use Absinthe.Schema.Notation

  @desc "A Video"
  object :video do
    field :id, :id
    field :title, :string
    field :description, :string
    field :url, :string

    field :category, :category do
      resolve(&ObeeWeb.Resolvers.Multimedia.get_video_category/3)
    end

    field :inserted_at, :datetime
    field :updated_at, :datetime
  end

  @desc "A Page"
  object :page do
    field :id, :id
    field :title, :string
    field :body, :string
  end

  @desc "A Video category"
  object :category do
    field :id, :id
    field :name, :string
  end


end
