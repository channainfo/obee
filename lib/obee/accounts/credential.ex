defmodule Obee.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset


  alias Obee.Accounts.User

  schema "credentials" do
    field :email, :string

    field :password, :string, virtual: true
    field :password_hash, :string
    # field :user_id, :id

    # Relations
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 8, max: 256)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass} } ->
        put_change(changeset, :password_hash, Comeonin.Pbkdf2.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
