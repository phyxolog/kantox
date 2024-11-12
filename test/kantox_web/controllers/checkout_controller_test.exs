defmodule KantoxWeb.CheckoutControllerTest do
  use KantoxWeb.ConnCase, async: false

  alias Kantox.Products.Product
  alias Kantox.Repo

  @product1 %Product{code: "GR1", name: "Green tea", price: 3.11}
  @product2 %Product{code: "SR1", name: "Strawberries", price: 5.00}
  @product3 %Product{code: "CF1", name: "Coffee", price: 11.23}

  describe "index" do
    test "returns error if params are invalid (response code: 422)", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/checkout", %{invalid: true})

      assert %{"errors" => %{"product_codes" => ["can't be blank"]}} = json_response(conn, 422)
    end

    test "returns a correct response (response code: 200)", %{conn: conn} do
      Repo.insert(Product.changeset(@product1))
      Repo.insert(Product.changeset(@product2))
      Repo.insert(Product.changeset(@product3))

      conn =
        post(conn, ~p"/api/v1/checkout", %{product_codes: ["GR1", "SR1", "GR1", "GR1", "CF1"]})

      %{"data" => %{"final_price" => "22.45"}} = json_response(conn, 200)

      conn =
        post(conn, ~p"/api/v1/checkout", %{product_codes: ["GR1", "GR1"]})

      %{"data" => %{"final_price" => "3.11"}} = json_response(conn, 200)

      conn =
        post(conn, ~p"/api/v1/checkout", %{product_codes: ["SR1", "SR1", "GR1", "SR1"]})

      %{"data" => %{"final_price" => "16.61"}} = json_response(conn, 200)

      conn =
        post(conn, ~p"/api/v1/checkout", %{product_codes: ["GR1", "CF1", "SR1", "CF1", "CF1"]})

      %{"data" => %{"final_price" => "30.57"}} = json_response(conn, 200)
    end
  end
end
