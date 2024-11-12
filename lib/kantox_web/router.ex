defmodule KantoxWeb.Router do
  use KantoxWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", KantoxWeb do
    pipe_through(:api)

    scope "/v1" do
      get("/products", ProductController, :index)
      post("/checkout", CheckoutController, :index)
    end
  end
end
