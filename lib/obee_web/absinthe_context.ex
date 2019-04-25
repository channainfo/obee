defmodule ObeeWeb.AbsintheContext do
  import Plug.Conn

  @behaviour Plug
  @one_day 86_400

  def  init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    authorization = get_req_header(conn, "authorization")
    case authorization do
      ["Bearer " <> token ] ->
        %{user_id: verify_user_id(token)}
      _ ->
        %{}
    end
  end

  def verify_user_id(nil), do: nil
  def verify_user_id(token) do
    result = Phoenix.Token.verify(ObeeWeb.Endpoint, "user_auth_token", token, max_age: @one_day)
    case result do
      {:ok, user_id} ->
        user_id
      _->
        nil
    end
  end

  # case Obee.Accounts.get_user(user_id) do
  #   %Obee.Accounts.User{} = user ->
  #     user
  #   _ ->
  #      nil
  # end

end
