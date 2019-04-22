defmodule ObeeWeb.Schema.DateTime do
  use Absinthe.Schema.Notation
  # https://stackoverflow.com/questions/45577500/how-can-i-use-timestamps-in-absinthe-phoenix-1-3
  # import_types Absinthe.Type.Custom
  @desc """
    datetime is in utc, however the date time that appear in JSON is in ISO8601 format string including UTC timezone ("Z")
    The parsed date and time string will be converted to UTC and any UTC offset other than 0 will be rejected.
  """

  scalar :datetime, name: "DateTime" do
    # We will serialize a datetime to iso8601
    serialize(fn(datetime) ->
      #IO.inspect(datetime)
      # IO.inspect(NaiveDateTime.to_iso8601(datetime))
      # datetime = DateTime.from_naive!(datetime, "Etc/UTC")
      # datetime = DateTime.to_iso8601(datetime)
      datetime = NaiveDateTime.to_iso8601(datetime)
      datetime
    end)
    # We will define a `parse_datetime/1` function for parsing
    parse(fn(datetime)->
      parse_datetime(datetime)
    end)
  end

  defp parse_datetime(%Absinthe.Blueprint.Input.String{value: value}) do

    case DateTime.from_iso8601(value) do
      {:ok, datetime, 0} -> {:ok, datetime}
      {:ok, _datetime, _offset} -> :error
      _error -> :error
    end
  end

  defp parse_datetime(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_datetime(_) do
    :error
  end
end
