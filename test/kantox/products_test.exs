defmodule Kantox.ProductsTest do
  use Kantox.DataCase, async: false

  alias Kantox.Products
  alias Kantox.Products.Product
  alias Kantox.Repo

  @product1 %Product{code: "GR1", name: "Green tea", price: 3.11}
  @product2 %Product{code: "CF1", name: "Coffee", price: 5.12}
  @product3 %Product{code: "GH1", name: "GH", price: 1.12}

  describe "list_products/1" do
    test "returns all products with pagination" do
      Repo.insert(Product.changeset(@product1))

      assert %Scrivener.Page{entries: [product]} = Products.list_products(%{})
      assert %Product{code: "GR1"} = product
    end
  end

  describe "list_products_by_codes/1" do
    test "returns all products by codes" do
      codes = ["GR1", "CF1"]

      Repo.insert(Product.changeset(@product1))
      Repo.insert(Product.changeset(@product2))
      Repo.insert(Product.changeset(@product3))

      assert [product, product2] = Products.list_products_by_codes(codes)
      assert product.code in codes
      assert product2.code in codes
    end
  end
end
