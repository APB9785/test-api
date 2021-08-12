defmodule PeekHomeWeb.Router do
  use PeekHomeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: PeekHomeWeb.Schema,
      socket: PeekHomeWeb.UserSocket

    forward "/", Absinthe.Plug, schema: PeekHomeWeb.Schema
  end
end
