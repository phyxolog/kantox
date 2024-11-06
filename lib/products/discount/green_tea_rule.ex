defmodule Kantox.Products.Discount.GreenTeaRule do
  @moduledoc """
  Buy-one-get-one-free rule for green tea orders.
  """

  @behaviour Kantox.Products.Discount

  @doc """
  iex> Kantox.Products.Discount.GreenTeaRule.apply(1, Decimal.from_float(5.45))
  Decimal.new("5.45")

  iex> Kantox.Products.Discount.GreenTeaRule.apply(2, Decimal.from_float(5.45))
  Decimal.new("5.45")

  iex> Kantox.Products.Discount.GreenTeaRule.apply(3, Decimal.from_float(5.45))
  Decimal.new("10.90")

  iex> Kantox.Products.Discount.GreenTeaRule.apply(4, Decimal.from_float(5.45))
  Decimal.new("10.90")
  """
  @impl Kantox.Products.Discount
  def apply(qty, price) do
    qty =
      Decimal.add(
        Decimal.div_int(qty, 2),
        Decimal.rem(qty, 2)
      )

    Decimal.mult(qty, price)
  end
end
