defmodule ObeeWeb.HelloView do
  use ObeeWeb, :view

  @spec request_detail(Plug.Conn.t()) :: <<_::64, _::_*8>>
  def request_detail(conn) do
    "Request handled by: #{controller_module(conn)}.#{action_name(conn)}"
  end

  def connection_keys(conn) do
    conn
    |> Map.from_struct()
    |> Map.keys()
  end
end
