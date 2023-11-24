defmodule FavouriteLinks.Repo do
  use Ecto.Repo,
    otp_app: :favourite_links,
    adapter: Ecto.Adapters.Postgres
end
