defmodule KantoxWeb.CheckoutJSON do
  @moduledoc false

  def index(%{final_price: final_price}) do
    %{
      data: %{
        final_price: final_price
      }
    }
  end
end
