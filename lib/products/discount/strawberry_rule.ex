defmodule Kantox.Products.Discount.StrawberryRule do
  @moduledoc """
  If you buy 3 or more strawberries, the price should drop to £4.50 per strawberry.
  """

  @behaviour Kantox.Products.Discount

  @price_per_item Decimal.from_float(4.50)

  @doc """
  iex> Kantox.Products.Discount.StrawberryRule.apply(2, Decimal.from_float(5.45))
  Decimal.new("10.90")

  iex> Kantox.Products.Discount.StrawberryRule.apply(3, Decimal.from_float(5.45))
  Decimal.new("13.5")
  """
  @impl Kantox.Products.Discount
  def apply(qty, price) do
    if Decimal.compare(qty, 3) in [:eq, :gt] do
      Decimal.mult(qty, @price_per_item)
    else
      Decimal.mult(qty, price)
    end
  end
end
