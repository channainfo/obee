defmodule Obee.Multimedia.Video do
  use Ecto.Schema
  import Ecto.Changeset

  alias Obee.Accounts.User
  alias Obee.Multimedia.Category
  alias Obee.Multimedia.Annotation

  @primary_key {:id, Obee.Multimedia.Permalink, autogenerate: true}

  schema "videos" do
    field :title, :string
    field :slug, :string
    field :url, :string
    field :description, :string

    field :imdb_id, :string
    field :tmdb_id, :string
    field :duration, :integer
    field :released_year, :integer
    field :public_rating, :float

    field :file, :string, virtual: true

    belongs_to :user, User
    belongs_to :category, Category
    has_many :annotations, Annotation

    timestamps()
  end

  defp slugify_title(changeset) do
    case fetch_change(changeset, :title) do
      {:ok, new_title} -> put_change(changeset, :slug, slugify(new_title))
      :error -> changeset
    end
  end

  defp slugify(title) do
    title
    |> String.downcase
    |> String.replace(~r/[^\w-]+/u, "-")
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:title, :description, :url, :category_id ])
    |> validate_required([:title, :description, :url ])
    |> assoc_constraint(:category)
    |> slugify_title()
  end
end
