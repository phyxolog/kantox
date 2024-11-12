defmodule KantoxWeb.ProductController do
  @moduledoc false

  use KantoxWeb, :controller

  alias Kantox.Products

  def index(conn, params) do
    products = Products.list_products(params)
    render(conn, :index, products: products)
  end
end
