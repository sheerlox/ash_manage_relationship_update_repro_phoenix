defmodule AshReproWeb.Router do
  use AshReproWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AshReproWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AshReproWeb do
    pipe_through :browser

    live_session :app do
      live "/", ProfileLive.Index, :index
      live "/new", ProfileLive.Index, :new
      live "/:id/edit", ProfileLive.Index, :edit

      live "/:id", ProfileLive.Show, :show
      live "/:id/show/edit", ProfileLive.Show, :edit
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", AshReproWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ash_repro, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AshReproWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
