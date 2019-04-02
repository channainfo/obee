defmodule Obee.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Obee.Accounts.Credential
  alias Obee.Multimedia.Video

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :username, :string

    # Relation
    has_one :credential, Credential
    has_many :videos, Video

    timestamps()
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end


  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :username])
    |> validate_required([:first_name, :last_name, :username])
    |> unique_constraint(:username)
  end
end
