defmodule Kantox.Products.Discount.BuyOneGetOne do
  @moduledoc """
  Implements a "Buy One Get One Free" discount strategy.
  For every two items purchased, one is free. In case of odd quantities,
  the remaining item is charged at full price.
  """

  @behaviour Kantox.Products.Discount

  @doc """
  iex> Kantox.Products.Discount.BuyOneGetOne.apply(1, Decimal.from_float(5.45), %{})
  Decimal.new("5.45")

  iex> Kantox.Products.Discount.BuyOneGetOne.apply(2, Decimal.from_float(5.45), %{})
  Decimal.new("5.45")

  iex> Kantox.Products.Discount.BuyOneGetOne.apply(3, Decimal.from_float(5.45), %{})
  Decimal.new("10.90")

  iex> Kantox.Products.Discount.BuyOneGetOne.apply(4, Decimal.from_float(5.45), %{})
  Decimal.new("10.90")
  """
  @impl Kantox.Products.Discount
  @spec apply(Decimal.t(), Decimal.t(), term()) :: Decimal.t()
  def apply(qty, price, _params) do
    qty =
      Decimal.add(
        Decimal.div_int(qty, 2),
        Decimal.rem(qty, 2)
      )

    Decimal.mult(qty, price)
  end
end
