defmodule FavouriteLinksWeb.UrlController do
  use FavouriteLinksWeb, :controller

  import Plug.Conn.Status, only: [code: 1]
  use PhoenixSwagger

  alias FavouriteLinks.Urls
  alias FavouriteLinks.Urls.Url

  action_fallback FavouriteLinksWeb.FallbackController

  swagger_path :index do
  get("/urls")
  description("List of all URLs")
  response(code(:ok), "Success")
end

  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _params) do
    urls = Urls.list_urls()
    render(conn, "index.json", urls: urls)
  end


  swagger_path :create do
  post("/urls")
  description("Create a new URL")
  response(code(:ok), "Success")
end

  def create(conn, %{"url" => url_params}) do
    with {:ok, %Url{} = url} <- Urls.create_url(url_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.url_path(conn, :show, url))
      |> render("show.json", url: url)
    end
  end

  swagger_path :show do
  get("/urls/{id}")
  description("Show a URL")
  response(code(:ok), "Success")
end

  def show(conn, %{"id" => id}) do
    url = Urls.get_url!(id)
    render(conn, "show.json", url: url)
  end

  swagger_path :update do
  put("/urls/{id}")
  description("Update a URL")
  response(code(:ok), "Success")
end

   def update(conn, %{"id" => id, "url" => url_params}) do
    url = Urls.get_url!(id)

    with {:ok, %Url{} = url} <- Urls.update_url(url, url_params) do
      render(conn, "show.json", url: url)
    end
  end

#   swagger_path :delete do
#   delete("/urls/{id}")
#   description("Delete a URL")
#   response(code(:ok), "Success")

# end

#   def delete(conn, %{"id" => id}) do
#     url = Urls.get_url!(id)

#     with {:ok, %Url{}} <- Urls.delete_url(url) do
#       send_resp(conn, :no_content, "")
#     end
#   end


end
