defmodule Kantox.Products.Product do
  @moduledoc """
  A module representing a product with a code, name, and price.
  """

  use Kantox.Schema

  alias Kantox.Products.Product

  @type code() :: String.t()

  @type t() :: %Product{
          code: code(),
          name: String.t(),
          price: Decimal.t()
        }

  @permitted ~w(code name price)a

  schema "products" do
    field :code, :string
    field :name, :string
    field :price, :decimal

    timestamps()
  end

  @doc false
  def changeset(%Product{} = product, attrs \\ %{}) do
    product
    |> cast(attrs, @permitted)
    |> validate_required(@permitted)
    |> validate_change(:price, &validate_price/2)
    |> check_constraint(:price, name: :price_greater_than_zero)
    |> unique_constraint(:code, name: :products_code_index)
  end

  defp validate_price(:price, price) do
    if Decimal.compare(price, 0) in [:lt, :eq] do
      [price: "cannot be less or equal to zero"]
    else
      []
    end
  end
end
