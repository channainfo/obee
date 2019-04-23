defmodule ObeeWeb.Resolvers.Account do
  def create_user(_, args, _) do
    case Obee.Accounts.create_user(args) do
      {:ok, result} -> {:ok, result}
      {:error, changeset } -> {:error, inspect(changeset.errors)}
    end
  end

  def authenticate(_, %{email: email, password: password}, _) do
    case Obee.Accounts.authenticate_by_email_and_pass(email, password) do
      {:ok, user} ->
        {:ok, Phoenix.Token.sign(ObeeWeb.Endpoint, "user_graphsql_auth", user.id) }
      {:error, error_type} ->
        {:error, "#{error_type}" }
    end
  end
end
