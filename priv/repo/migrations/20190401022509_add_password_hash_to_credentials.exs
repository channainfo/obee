defmodule Obee.Repo.Migrations.AddPasswordHashToCredentials do
  use Ecto.Migration

  def change do
    alter table(:credentials) do
      add :password_hash, :string
    end
  end
end
