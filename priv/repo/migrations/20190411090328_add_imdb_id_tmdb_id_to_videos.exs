defmodule Obee.Repo.Migrations.AddImdbIdTmdbIdToVideos do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :imdb_id, :string
      add :tmdb_id, :string
      add :duration, :string
      add :released_year, :integer
      add :public_rating, :float
    end

  end
end
