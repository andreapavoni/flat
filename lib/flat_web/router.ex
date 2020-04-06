defmodule FlatWeb.Router do
  use FlatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", FlatWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/blog/", BlogController, :list
    get "/blog/tag/:tag", BlogController, :list_by_tag
    get "/blog/:id", BlogController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", FlatWeb do
  #   pipe_through :api
  # end
end
