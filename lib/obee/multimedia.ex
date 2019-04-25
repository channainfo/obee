defmodule Obee.Multimedia do
  @moduledoc """
  The Multimedia context.
  """
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Obee.Repo

  alias Obee.Multimedia.Video
  alias Obee.Multimedia.Category
  alias Obee.Multimedia.Annotation

  alias Obee.Accounts.User



  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos()
      [%Video{}, ...]

  """
  def list_videos do
    Video
    |> Repo.all()
    |> preload_user()
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(id), do: preload_user(Repo.get!(Video, id))

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(%User{} = user,  attrs \\ %{}) do
    attrs = set_attrs_with_url(attrs, user)
    changeset = %Video{}
    |> Video.changeset(attrs)
    |> put_assoc(:user, user)

    changeset = case Map.has_key?(attrs, "category_id") || Map.has_key?(attrs, :category_id ) do
      true ->
        category = get_category!(attrs.category_id)
        changeset
        |> put_assoc(:category, category)
      _ ->
        changeset
    end

    changeset
    |> Repo.insert()
  end

  # Ecto.Changeset.put_assoc(changeset, :user, user)

  def set_attrs_with_url(attrs, user) do
    keys = case Map.has_key?(attrs, :url) do
      true -> {:url, :file}
      false -> {"url", "file"}
    end
    {url_key, file_key} = keys


    url_value = case upload = attrs[file_key] do
      %Plug.Upload{} ->
        # extension = Path.extname(upload.filename)
        file_name = "#{user.id}-#{upload.filename}"
        root = File.cwd!
        location = "#{root}/media/#{file_name}"
        File.cp!(upload.path, location)
        file_name
      _ ->
        attrs[url_key]
    end

    Map.put(attrs, url_key, url_value)
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video(%Video{} = video, attrs) do
    attrs = set_attrs_with_url(attrs, video.user)
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{source: %Video{}}

  """
  def change_video(%User{} = user, %Video{} = video) do
    video
    |> Video.changeset(%{})
    |> put_assoc(:user, user)
  end

  def put_user(changeset, user) do
    # Ecto.Changeset.put_change(changeset, :user_id, user.id)
    Ecto.Changeset.put_assoc(changeset, :user, user)
  end

  defp user_videos_query(query, %User{id: user_id}) do
    from(v in query, where: v.user_id == ^user_id)
  end

  def list_user_videos(%User{} = user) do
    Video
    |> user_videos_query(user)
    |> Repo.all()
    |> preload_user()
  end

  def get_user_video!(%User{} = user, id) do
    from(v in Video, where: v.id == ^id)
    |> user_videos_query(user)
    |> Repo.one!()
    |> preload_user()
  end

  def preload_user(video_or_videos) do
    Repo.preload(video_or_videos, [:user, :category])
  end

  def create_category(name) do
    Repo.get_by(Category, name: name) || Repo.insert!(%Category{name: name})
  end

  def get_category!(id)do
    Repo.get(Obee.Multimedia.Category, id)
  end

  def list_alphabetical_categories do
    Category
    |> Category.alphabetical()
    |> Repo.all()
  end

  def annotate_video(%User{} = user, video_id, attrs) do
    %Annotation{video_id: video_id}
    |> Annotation.changeset(attrs)
    |> put_assoc(:user, user)
    |> Repo.insert()
  end

  def list_annotations(%Video{} = video, since_id \\ 0) do
    query = from a in Ecto.assoc(video, :annotations),
            where: a.id > ^since_id,
            order_by: [asc: a.at, asc: a.id],
            limit: 500, preload: [:user]
    Repo.all(query)
  end


end
