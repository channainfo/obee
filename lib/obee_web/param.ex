defimpl Phoenix.Param, for: Obee.Multimedia.Video do
  def to_param(%{slug: slug, id: id}) do
    "#{id}-#{slug}"
  end

end
