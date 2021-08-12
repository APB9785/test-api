defmodule PeekHomeWeb.Router do
  use PeekHomeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PeekHomeWeb do
    pipe_through :api
  end
end
