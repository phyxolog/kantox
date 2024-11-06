defmodule Kantox.Products.Discount.CoffeeRule do
  @moduledoc """
  If you buy 3 or more coffees, the price of all coffees should drop to two thirds of the original price.
  """

  @behaviour Kantox.Products.Discount

  @discount Decimal.from_float(2 / 3)

  @doc """
  iex> Kantox.Products.Discount.CoffeeRule.apply(2, Decimal.from_float(5.45))
  Decimal.new("10.90")

  iex> Kantox.Products.Discount.CoffeeRule.apply(3, Decimal.from_float(5.45))
  Decimal.new("10.899999999999998910")

  iex> Kantox.Products.Discount.CoffeeRule.apply(4, Decimal.from_float(5.45))
  Decimal.new("14.533333333333331880")
  """
  @impl Kantox.Products.Discount
  def apply(qty, price) do
    if Decimal.compare(qty, 3) in [:eq, :gt] do
      qty
      |> Decimal.mult(price)
      |> Decimal.mult(@discount)
    else
      Decimal.mult(qty, price)
    end
  end
end
