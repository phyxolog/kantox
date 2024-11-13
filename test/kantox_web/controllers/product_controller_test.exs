defmodule KantoxWeb.ProductControllerTest do
  use KantoxWeb.ConnCase, async: false

  alias Kantox.Products.Product
  alias Kantox.Repo

  @product1 %Product{code: "GR1", name: "Green tea", price: 3.11}
  @product2 %Product{code: "CF1", name: "Coffee", price: 5.12}
  @product3 %Product{code: "GH1", name: "GH", price: 1.12}

  setup do
    Repo.insert(Product.changeset(@product1))
    Repo.insert(Product.changeset(@product2))
    Repo.insert(Product.changeset(@product3))

    :ok
  end

  describe "index" do
    test "returns empty list of products (response code: 200)", %{conn: conn} do
      Repo.delete_all(Product)

      conn = get(conn, ~p"/api/v1/products")

      assert %{
               "data" => [],
               "metadata" => %{
                 "page_number" => 1,
                 "page_size" => 100,
                 "total_entries" => 0,
                 "total_pages" => 1
               }
             } = json_response(conn, 200)
    end

    test "returns list of products (response code: 200)", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/products")

      assert %{
               "data" => [
                 %{
                   "code" => "GR1",
                   "id" => 1,
                   "name" => "Green tea",
                   "price" => "3.11"
                 },
                 %{
                   "code" => "CF1",
                   "id" => 2,
                   "name" => "Coffee",
                   "price" => "5.12"
                 },
                 %{
                   "code" => "GH1",
                   "id" => 3,
                   "name" => "GH",
                   "price" => "1.12"
                 }
               ],
               "metadata" => %{
                 "page_number" => 1,
                 "page_size" => 100,
                 "total_entries" => 3,
                 "total_pages" => 1
               }
             } = json_response(conn, 200)
    end

    test "returns list of products with pagination (response code: 200)", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/products", %{page_size: 1})

      assert %{
               "data" => [
                 %{
                   "code" => "GR1",
                   "id" => 1,
                   "name" => "Green tea",
                   "price" => "3.11"
                 }
               ],
               "metadata" => %{
                 "page_number" => 1,
                 "page_size" => 1,
                 "total_entries" => 3,
                 "total_pages" => 3
               }
             } = json_response(conn, 200)

      conn = get(conn, ~p"/api/v1/products", %{page_size: 1, page: 2})

      assert %{
               "data" => [
                 %{
                   "code" => "CF1",
                   "id" => 2,
                   "name" => "Coffee",
                   "price" => "5.12"
                 }
               ],
               "metadata" => %{
                 "page_number" => 2,
                 "page_size" => 1,
                 "total_entries" => 3,
                 "total_pages" => 3
               }
             } = json_response(conn, 200)
    end
  end
end
