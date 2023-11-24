defmodule FavouriteLinksWeb.PageController do
  use FavouriteLinksWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
