defmodule KantoxWeb.CheckoutController do
  @moduledoc false

  use KantoxWeb, :controller

  alias Ecto.Changeset
  alias Kantox.Checkout
  alias Kantox.Products

  action_fallback(KantoxWeb.FallbackController)

  def index(conn, params) do
    changeset = changeset(params)

    with {:ok, %{product_codes: product_codes}} <- Changeset.apply_action(changeset, :prepare) do
      products_map =
        product_codes
        |> Products.list_products_by_codes()
        |> Map.new(&{&1.code, &1})

      products =
        product_codes
        |> Stream.map(&Map.get(products_map, &1))
        |> Enum.reject(&is_nil/1)

      checkout =
        Checkout.discount_rules()
        |> Checkout.new()
        |> Checkout.add_products(products)

      render(conn, :index, final_price: Checkout.final_price(checkout))
    end
  end

  defp changeset(attrs) do
    types = %{
      product_codes: {:array, :string}
    }

    {%{}, types}
    |> Changeset.cast(attrs, Map.keys(types))
    |> Changeset.validate_required(Map.keys(types))
  end
end
