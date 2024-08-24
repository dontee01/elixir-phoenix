defmodule Pms.Repo do
  use Ecto.Repo,
    otp_app: :pms,
    adapter: Ecto.Adapters.Postgres
end
