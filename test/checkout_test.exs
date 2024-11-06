defmodule Kantox.CheckoutTest do
  use ExUnit.Case, async: true
  doctest Kantox.Checkout

  alias Kantox.Checkout
  alias Kantox.Checkout.CartItem
  alias Kantox.Products.Discount
  alias Kantox.Products.Product

  @discount_rules %{
    "GR1" => Discount.GreenTeaRule,
    "SR1" => Discount.StrawberryRule,
    "CF1" => Discount.CoffeeRule
  }

  @product1 Product.new!("GR1", "Green tea", Decimal.from_float(3.11))
  @product2 Product.new!("SR1", "Strawberries", Decimal.from_float(5.00))
  @product3 Product.new!("CF1", "Strawberries", Decimal.from_float(11.23))

  describe "add_product/2" do
    test "returns an updated Checkout struct with a new item in the cart" do
      checkout = Checkout.new()

      assert map_size(checkout.cart) == 0

      checkout = Checkout.add_product(checkout, @product1)
      assert %Checkout{cart: %{"GR1" => %CartItem{qty: 1, price: _}}} = checkout
    end
  end

  describe "final_price/1" do
    test "returns zero for empty checkout" do
      checkout = Checkout.new()
      assert Checkout.final_price(checkout) == Decimal.new("0.00")
    end

    test "returns a correct price for GR1,SR1,GR1,GR1,CF1 products without discounts" do
      checkout =
        Checkout.new()
        |> Checkout.add_product(@product1)
        |> Checkout.add_product(@product2)
        |> Checkout.add_product(@product1)
        |> Checkout.add_product(@product1)
        |> Checkout.add_product(@product3)

      assert Checkout.final_price(checkout) == Decimal.from_float(25.56)
    end

    test "returns a correct price for GR1,SR1,GR1,GR1,CF1 products appying discounts" do
      checkout =
        @discount_rules
        |> Checkout.new()
        |> Checkout.add_product(@product1)
        |> Checkout.add_product(@product2)
        |> Checkout.add_product(@product1)
        |> Checkout.add_product(@product1)
        |> Checkout.add_product(@product3)

      assert Checkout.final_price(checkout) == Decimal.from_float(22.45)
    end

    test "returns a correct price for GR1,GR1 products appying discounts" do
      checkout =
        @discount_rules
        |> Checkout.new()
        |> Checkout.add_product(@product1)
        |> Checkout.add_product(@product1)

      assert Checkout.final_price(checkout) == Decimal.from_float(3.11)
    end

    test "returns a correct price for SR1,SR1,GR1,SR1 products appying discounts" do
      checkout =
        @discount_rules
        |> Checkout.new()
        |> Checkout.add_product(@product2)
        |> Checkout.add_product(@product2)
        |> Checkout.add_product(@product1)
        |> Checkout.add_product(@product2)

      assert Checkout.final_price(checkout) == Decimal.from_float(16.61)
    end

    test "returns a correct price for GR1,CF1,SR1,CF1,CF1 products appying discounts" do
      checkout =
        @discount_rules
        |> Checkout.new()
        |> Checkout.add_product(@product1)
        |> Checkout.add_product(@product3)
        |> Checkout.add_product(@product2)
        |> Checkout.add_product(@product3)
        |> Checkout.add_product(@product3)

      assert Checkout.final_price(checkout) == Decimal.from_float(30.57)
    end
  end
end
