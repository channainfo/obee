defmodule Obee.Multimedia.Permalink do
  @behaviour Ecto.Type

  def type, do: :id

  def cast(binary) when is_binary(binary) do
    case Integer.parse(binary) do
      {int, _} when int > 0 -> {:ok, int}
      _ -> :error
    end
  end

  def cast(intval) when is_integer(intval) do
    {:ok, intval}
  end

  def cast(_) do
    :error
  end

  def dump(val) when is_integer(val) do
    {:ok, val}
  end

  def load(val) when is_integer(val) do
    {:ok, val}
  end

end
