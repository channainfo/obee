defmodule ObeeWeb.AbsintheContext do
  import Plug.Conn

  @behaviour Plug
  @one_day 86_400

  def  init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    # IO.inspect("context: #{context}")
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    authorization = get_req_header(conn, "authorization")
    case authorization do
      ["Bearer " <> token ] ->
        %{current_user: get_user(token)}
      _ ->
        IO.inspect("unmatched")
        %{current_user: nil}
    end
  end

  def get_user(nil), do: nil
  def get_user(token) do
    result = Phoenix.Token.verify(ObeeWeb.Endpoint, "user_graphsql_auth", token, max_age: @one_day)
    case result do
      {:ok, user_id} ->
        case Obee.Accounts.get_user(user_id) do
          %Obee.Accounts.User{} = user ->
            IO.inspect(user)
            user
          _ ->
             nil
        end
      _-> nil
    end
  end

end
