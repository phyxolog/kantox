defmodule Kantox.Products.Discount do
  @moduledoc """
  A behaviour module for defining discount strategies on products.
  """

  @type behaviour_module() :: module()

  @callback apply(qty :: Decimal.t(), price :: Decimal.t()) :: Decimal.t()
end
