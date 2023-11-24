defmodule FavouriteLinksWeb.Router do
  use FavouriteLinksWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FavouriteLinksWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]


  end

  def swagger_info do
    %{
      schemes: ["http", "https", "ws", "wss"],
      info: %{
        version: "1.0",
        title: "FavouriteLinks API",
        description: "API Documentation for FavouriteLinks",
        termsOfService: "Open for public",
        contact: %{
          name: "Kiprotich Kimutai",
          email: "kiprotichkimutai01@gmail.com"
        }
      },
      securityDefinitions: %{
        Bearer: %{
          type: "apiKey",
          name: "Authorization",
          description:
          "API Token must be provided via `Authorization: Bearer ` header",
      in: "header"
        }
      },
      consumes: ["application/json"],
      produces: ["application/json"],
      tags: [
        %{name: "Urls", description: "Operations about Urls"},
      ]
    }
  end

  scope "/", FavouriteLinksWeb do
    pipe_through :browser


    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", FavouriteLinksWeb do
    pipe_through :api
    resources "/urls", UrlController, except: [:new, :edit]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FavouriteLinksWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
