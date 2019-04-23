defmodule Obee.Repo do
  use Ecto.Repo, otp_app: :obee, adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10
end
