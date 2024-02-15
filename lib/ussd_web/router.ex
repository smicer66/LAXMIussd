defmodule UssdWeb.Router do
  use UssdWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :no_layout do
    plug :put_layout, false
  end

  scope "/", UssdWeb do
    pipe_through :browser
    get "/", HomeController, :home_page

    get "/user", UserController, :user_management
    post "/user", UserController, :user_create

    get "/mno_sent", LogsController, :mno_logs_sent
    get "/mno_recieved", LogsController, :mno_logs_recieved

    get "/configs", ConfigsController, :configs

  end

  # Other scopes may use custom stacks.
  scope "/", UssdWeb do
    pipe_through :api

    get "/mtninit", MtnController, :mtn_run
    post "/mtninit", MtnController, :mtn_run

    get "/airtelinit", AirtelController, :airtel_run
    post "/airtelinit", AirtelController, :airtel_run

    get "/zamtelinit", ZamtelController, :zamtel_run
    post "/zamtelinit", ZamtelController, :zamtel_run
  end
end
