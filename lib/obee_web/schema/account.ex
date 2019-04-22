defmodule ObeeWeb.Schema.Account do
  use Absinthe.Schema.Notation

  @desc "A User"
  object :user do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
    field :username, :string

    # field :credential, :credential
    # field :video, :video
  end

  @desc "Credential"
  object :credential do
    field :id, :id
    field :email, :string
  end

  @desc "Credential input"
  input_object :credential_input do
    field :id, :integer
    field :email, :string
    field :password, :string
  end

end
