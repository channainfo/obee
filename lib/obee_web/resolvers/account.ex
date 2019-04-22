defmodule ObeeWeb.Resolvers.Account do
  def create_user(_, args, _) do
    case Obee.Accounts.create_user(args) do
      {:ok, result} -> {:ok, result}
      {:error, changeset } -> {:error, inspect(changeset.errors)}
    end
  end
end
