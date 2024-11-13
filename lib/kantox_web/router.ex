defmodule KantoxWeb.Router do
  use KantoxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: KantoxWeb.Api.Spec
  end

  scope "/" do
    pipe_through :browser

    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end

  scope "/api" do
    pipe_through :api

    get "/openapi", OpenApiSpex.Plug.RenderSpec, :show

    scope "/v1", KantoxWeb do
      get "/products", ProductController, :index
      post "/checkout", CheckoutController, :index
    end
  end
end
