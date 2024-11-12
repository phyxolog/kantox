defmodule Kantox.Products.Discount.QuantityBasedTest do
  use ExUnit.Case, async: true

  alias Kantox.Products.Discount.QuantityBased

  describe "apply/3" do
    test "returns correct price with applied rule (discount mode)" do
      assert QuantityBased.apply(
               2,
               Decimal.from_float(5.45),
               %QuantityBased{
                 compare_in: [:eq, :gt],
                 count: Decimal.new(3),
                 mode: :discount,
                 value: Decimal.from_float(2 / 3)
               }
             ) == Decimal.new("10.90")

      assert QuantityBased.apply(
               3,
               Decimal.from_float(5.45),
               %Kantox.Products.Discount.QuantityBased{
                 compare_in: [:eq, :gt],
                 count: Decimal.new(3),
                 mode: :discount,
                 value: Decimal.from_float(2 / 3)
               }
             ) == Decimal.new("10.899999999999998910")

      assert QuantityBased.apply(
               4,
               Decimal.from_float(5.45),
               %Kantox.Products.Discount.QuantityBased{
                 compare_in: [:eq, :gt],
                 count: Decimal.new(3),
                 mode: :discount,
                 value: Decimal.from_float(2 / 3)
               }
             ) == Decimal.new("14.533333333333331880")
    end

    test "returns correct price with applied rule (fixed_price mode)" do
      assert QuantityBased.apply(
               2,
               Decimal.from_float(5.45),
               %Kantox.Products.Discount.QuantityBased{
                 compare_in: [:eq, :gt],
                 count: Decimal.new(3),
                 mode: :fixed_price,
                 value: Decimal.from_float(4.50)
               }
             ) == Decimal.new("10.90")

      assert QuantityBased.apply(
               3,
               Decimal.from_float(5.45),
               %Kantox.Products.Discount.QuantityBased{
                 compare_in: [:eq, :gt],
                 count: Decimal.new(3),
                 mode: :fixed_price,
                 value: Decimal.from_float(4.50)
               }
             ) == Decimal.new("13.5")
    end
  end
end
