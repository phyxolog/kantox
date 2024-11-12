defmodule Kantox.Products do
  @moduledoc "Provides functions to interact with `Product` data in the database"

  import Ecto.Query

  alias Kantox.Products.Product
  alias Kantox.Repo

  @doc "Retrieves all `Product` records from the database"
  @spec list_products(map()) :: Scrivener.Page.t()
  def list_products(params) do
    Repo.paginate(Product, params)
  end

  @doc "Retrieves a list of `Product` records that match a given list of product codes"
  @spec list_products_by_codes([Product.code()]) :: [Product.t()]
  def list_products_by_codes(codes) do
    Product
    |> where([p], p.code in ^codes)
    |> Repo.all()
  end
end
