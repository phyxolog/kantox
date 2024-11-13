defmodule Kantox.Products.Discount.QuantityBased do
  @moduledoc """
  Implements quantity-based pricing rules supporting both percentage discounts and fixed pricing.

  Discount rules are defined by quantity thresholds and can either reduce the price by a percentage
  or set a fixed unit price when conditions are met.

  ## Examples:

    # 10% discount for quantities over 100
    %QuantityBased{
      compare_in: [:gt],
      count: Decimal.new("100"),
      mode: :discount,
      value: Decimal.new("0.9")
    }

    # set fixed price (4.50) for each product and quantities over or equal 3
    %QuantityBased{
      compare_in: [:gt, :lt],
      count: Decimal.new(3),
      mode: :fixed_price,
      value: Decimal.new("4.50")
    }
  """

  alias Kantox.Products.Discount.QuantityBased

  defstruct [:compare_in, :count, :mode, :value]

  @behaviour Kantox.Products.Discount

  @type t() :: %QuantityBased{
          compare_in: list(:lt | :gt | :eq),
          count: Decimal.t(),
          mode: :discount | :fixed_price,
          value: Decimal.t()
        }

  @doc false
  @impl Kantox.Products.Discount
  @spec apply(Decimal.t(), Decimal.t(), t()) :: Decimal.t()
  def apply(qty, price, %QuantityBased{mode: :discount} = rule) do
    if applicable?(qty, rule) do
      qty
      |> Decimal.mult(price)
      |> Decimal.mult(rule.value)
    else
      Decimal.mult(qty, price)
    end
  end

  def apply(qty, price, %QuantityBased{mode: :fixed_price} = rule) do
    if applicable?(qty, rule) do
      Decimal.mult(qty, rule.value)
    else
      Decimal.mult(qty, price)
    end
  end

  defp applicable?(qty, %QuantityBased{} = rule) do
    Decimal.compare(qty, rule.count) in rule.compare_in
  end
end
