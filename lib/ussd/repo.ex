defmodule Ussd.Repo do
  use Ecto.Repo,
    otp_app: :ussd,
    # -------------------- postgress
    # adapter: Ecto.Adapters.Postgres

    # -------------------- mssql
    adapter: Ecto.Adapters.Tds
end
