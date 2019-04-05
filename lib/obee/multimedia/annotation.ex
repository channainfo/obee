defmodule Obee.Multimedia.Annotation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Obee.Accounts.User
  alias Obee.Multimedia.Video


  schema "annotations" do
    field :at, :integer
    field :body, :string

    belongs_to :user, User
    belongs_to :video, Video

    timestamps()
  end

  @doc false
  def changeset(annotation, attrs) do
    annotation
    |> cast(attrs, [:body, :at])
    |> validate_required([:body, :at])
  end
end
