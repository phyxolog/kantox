defmodule KantoxWeb.ProductController do
  @moduledoc false

  use KantoxWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Kantox.Products
  alias KantoxWeb.Api.Schemas

  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true

  tags ["Products"]

  operation :index,
    summary: "List products",
    description: "List all products with pagination",
    parameters: [
      page: [in: :query, description: "Page number", type: :integer],
      page_size: [in: :query, description: "Page size", type: :integer]
    ],
    responses: [
      ok: {"Product List Response", "application/json", Schemas.ProductsResponse}
    ]

  def index(conn, params) do
    products = Products.list_products(params)
    render(conn, :index, products: products)
  end
end
