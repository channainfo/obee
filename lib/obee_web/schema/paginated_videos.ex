defmodule ObeeWeb.Schema.PaginatedVideos do
  use Absinthe.Schema.Notation

  object :paginated_videos do
    # field :page_number, :integer do
    #   resolve(fn(parent, _args, _context) ->
    #     {:ok, parent.page_number }
    #   end)
    # end

    # field :per_page, :integer do
    #   resolve(fn(parent, _args, _context)->
    #     parent.page_size
    #   end)
    # end

    field :page_number, :integer
    field :page_size, :integer
    field :total_pages, :integer
    field :total_entries, :integer
    field :entries, list_of(:video)
  end

end
