defmodule Obee.Repo do
  use Ecto.Repo,
    otp_app: :obee,
    adapter: Ecto.Adapters.Postgres
end
