defmodule Kantox.Products.Product do
  @moduledoc """
  A module representing a product with a code, name, and price. All fields are required (enforced).
  """

  alias Kantox.Products.Product

  @type code() :: String.t()

  @type t() :: %__MODULE__{
          code: code(),
          name: String.t(),
          price: Decimal.t()
        }

  @enforce_keys [:code, :name, :price]
  defstruct [:code, :name, :price]

  @doc """
  Creates a new `%Product{}` struct with the specified attributes.

  Raises a RuntimeError if price is less or equal to zero.

  iex> Kantox.Products.Product.new!("P001", "Widget", Decimal.new("19.99"))
  %Kantox.Products.Product{code: "P001", name: "Widget", price: Decimal.from_float(19.99)}

  iex> Kantox.Products.Product.new!("P002", "Gadget", Decimal.from_float(0.00))
  ** (RuntimeError) Price should be greater than zero
  """
  @spec new!(code(), String.t(), Decimal.t()) :: t()
  def new!(code, name, price) do
    if Decimal.compare(price, 0) in [:lt, :eq] do
      raise RuntimeError, message: "Price should be greater than zero"
    end

    %Product{code: code, name: name, price: price}
  end
end
