defmodule KantoxWeb.CheckoutController do
  @moduledoc false

  use KantoxWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Kantox.Checkout
  alias Kantox.Products
  alias KantoxWeb.Api.Schemas
  alias OpenApiSpex.Reference

  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true

  tags ["Checkout"]

  operation :index,
    summary: "Shopping cart checkout",
    description: "Shopping cart checkout",
    request_body: {"Checkout Request", "application/json", Schemas.CheckoutRequest},
    responses: [
      ok: {"Checkout Response", "application/json", Schemas.CheckoutResponse},
      unprocessable_entity: %Reference{"$ref": "#/components/responses/unprocessable_entity"}
    ]

  def index(%Plug.Conn{body_params: body_params} = conn, _params) do
    products_map =
      body_params.product_codes
      |> Products.list_products_by_codes()
      |> Map.new(&{&1.code, &1})

    products =
      body_params.product_codes
      |> Stream.map(&Map.get(products_map, &1))
      |> Enum.reject(&is_nil/1)

    checkout =
      Checkout.discount_rules()
      |> Checkout.new()
      |> Checkout.add_products(products)

    :telemetry.execute([:kantox, :checkout, :products], %{count: length(products)}, %{})

    render(conn, :index, final_price: Checkout.final_price(checkout))
  end
end
