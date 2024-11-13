defmodule Kantox.Checkout do
  @moduledoc """
  Implements a flexible checkout system with support for configurable product-specific discount rules.

  The checkout system maintains a shopping cart and applies discount rules per product.
  Each product can have its own discount strategy (e.g., quantity-based discounts, buy-one-get-one, etc.).

  ## Usage

      # Initialize a checkout with discount rules
      checkout = Checkout.new(%{
        "TSHIRT" => %QuantityBased{
          compare_in: [:gt],
          count: Decimal.new("3"),
          mode: :discount,
          value: Decimal.new("0.9")  # 10% off when buying more than 3
        }
      })

      # Add products
      checkout = checkout
        |> Checkout.add_product(%Product{code: "TSHIRT", price: Decimal.new("20.00")})
        |> Checkout.add_product(%Product{code: "TSHIRT", price: Decimal.new("20.00")})

      # Calculate final price with discounts applied
      final_price = Checkout.final_price(checkout)
  """

  alias Kantox.Checkout
  alias Kantox.Products.Discount
  alias Kantox.Products.Product

  @default_price_precision 2

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
          Product.code() => Discount.behaviour_module() | struct()
        }

  @type t() :: %__MODULE__{
          cart: %{Product.code() => CartItem.t()},
          discount_rules: discount_rules()
        }

  @doc "Returns discount rules retrieves from the configuration"
  @spec discount_rules() :: discount_rules()
  def discount_rules do
    # Done it here through application configuration for the purpose of a test task
    # In a real-world scenario, this should be stored in the database
    Application.fetch_env!(:kantox, Discount)[:rules]
  end

  @doc """
  Creates a new checkout instance.

  The `discount_rules` parameter is a map of product codes to modules (implementation of `Discount`) that implement
  the discount logic for that product.

  iex> Kantox.Checkout.new()
  %Kantox.Checkout{cart: %{}, discount_rules: %{}}

  iex> Kantox.Checkout.new(%{"CODE" => __MODULE__})
  %Kantox.Checkout{cart: %{}, discount_rules: %{"CODE" => __MODULE__}}
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

  @doc false
  def add_products(%Checkout{} = checkout, products) do
    Enum.reduce(products, checkout, fn product, acc ->
      Checkout.add_product(acc, product)
    end)
  end

  @doc "Return a final price for a cart applying discount rules"
  @spec final_price(t()) :: Decimal.t()
  def final_price(
        %Checkout{cart: cart, discount_rules: discount_rules},
        places \\ @default_price_precision
      ) do
    sum =
      Enum.reduce(cart, Decimal.new(0), fn {product_code, %CartItem{} = cart_item}, acc ->
        Decimal.add(
          apply_discount_rules(discount_rules, product_code, cart_item),
          acc
        )
      end)

    Decimal.round(sum, places)
  end

  defp apply_discount_rules(discount_rules, product_code, %CartItem{} = cart_item) do
    case Map.fetch(discount_rules, product_code) do
      {:ok, %discount_rule_module{} = discount_rule} ->
        discount_rule_module.apply(cart_item.qty, cart_item.price, discount_rule)

      {:ok, discount_rule} ->
        discount_rule.apply(cart_item.qty, cart_item.price, %{})

      :error ->
        Decimal.mult(cart_item.qty, cart_item.price)
    end
  end
end
