defmodule Obee.Multimedia.Video do
  use Ecto.Schema
  import Ecto.Changeset

  alias Obee.Accounts.User

  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:title, :description, :url ])
    |> validate_required([:title, :description, :url ])
  end
end
