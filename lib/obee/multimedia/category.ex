defmodule Obee.Multimedia.Category do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Obee.Multimedia.Video

  schema "categories" do
    field :name, :string

    has_many :videos, Video

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  # def alphabetical(query) do
  #   from c in query, order_by: c.name
  # end

  def alphabetical(query) do
    from c in query, order_by: c.name
  end
end
