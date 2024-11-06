defmodule Kantox.Checkout do
  @moduledoc """
  This module handles the checkout process for a shopping cart.

  It provides functions to:
    - Create a new checkout instance
    - Add products to the cart
    - Calculate the final price of the cart, applying any applicable discount rules
  """

  alias Kantox.Checkout
  alias Kantox.Products.Product

  @price_precision 2

  defmodule CartItem do
    @moduledoc "Represents a single item in the shopping cart"

    @type t() :: %__MODULE__{
            qty: Decimal.t(),
            price: Decimal.t()
          }

    defstruct [:qty, :price]
  end

  @enforce_keys [:cart, :discount_rules]
  defstruct [:cart, :discount_rules]

  @type discount_rules() :: %{
          Product.code() => Kantox.Products.Discount.behaviour_module()
        }

  @type t() :: %__MODULE__{
          cart: %{Product.code() => CartItem.t()},
          discount_rules: discount_rules()
        }

  @doc """
  Creates a new checkout instance.

  The `discount_rules` parameter is a map of product codes to modules (implementation of `Kantox.Products.Discount`) that implement
  the discount logic for that product.

  iex> Kantox.Checkout.new()
  %Kantox.Checkout{cart: %{}, discount_rules: %{}}

  iex> Kantox.Checkout.new(%{"CODE" => Kantox.Products.Product.new!("CODE", "", Decimal.new(1))})
  %Kantox.Checkout{cart: %{}, discount_rules: %{"CODE" => %Kantox.Products.Product{code: "CODE", name: "", price: Decimal.new(1)}}}
  """
  @spec new(discount_rules()) :: t()
  def new(discount_rules \\ Map.new()) do
    %Checkout{
      cart: Map.new(),
      discount_rules: discount_rules
    }
  end

  @doc """
  Adds a product to the checkout's cart.

  If the product is already in the cart, the quantity is incremented.

  Returns the updated checkout instance.
  """
  @spec add_product(t(), Product.t()) :: t()
  def add_product(%Checkout{cart: cart} = checkout, %Product{} = product) do
    cart =
      Map.update(
        cart,
        product.code,
        %CartItem{qty: 1, price: product.price},
        &%CartItem{&1 | qty: &1.qty + 1}
      )

    %Checkout{checkout | cart: cart}
  end

  @doc "Return a final price for a cart applying discount rules"
  @spec final_price(t()) :: Decimal.t()
  def final_price(%Checkout{cart: cart, discount_rules: discount_rules}) do
    sum =
      Enum.reduce(cart, Decimal.new(0), fn {product_code, %CartItem{} = cart_item}, acc ->
        Decimal.add(
          apply_discount_rules(discount_rules, product_code, cart_item),
          acc
        )
      end)

    Decimal.round(sum, @price_precision)
  end

  defp apply_discount_rules(discount_rules, product_code, %CartItem{} = cart_item) do
    case Map.fetch(discount_rules, product_code) do
      {:ok, discount_rule} -> discount_rule.apply(cart_item.qty, cart_item.price)
      :error -> Decimal.mult(cart_item.qty, cart_item.price)
    end
  end
end
