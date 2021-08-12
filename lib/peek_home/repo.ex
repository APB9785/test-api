defmodule PeekHome.Repo do
  use Ecto.Repo,
    otp_app: :peek_home,
    adapter: Ecto.Adapters.Postgres
end
