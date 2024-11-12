defmodule Kantox.Repo do
  use Ecto.Repo, otp_app: :kantox, adapter: Ecto.Adapters.SQLite3
  use Scrivener, page_size: 100
end
