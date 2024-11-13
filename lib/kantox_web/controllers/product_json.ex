defmodule KantoxWeb.ProductJSON do
  @moduledoc false

  alias Kantox.Products.Product

  def index(%{products: %Scrivener.Page{} = page}) do
    %{
      data: Enum.map(page.entries, &render_product/1),
      metadata: %{
        page_number: page.page_number,
        page_size: page.page_size,
        total_pages: page.total_pages,
        total_entries: page.total_entries
      }
    }
  end

  defp render_product(%Product{} = product) do
    %{
      id: product.id,
      code: product.code,
      name: product.name,
      price: product.price,
      inserted_at: product.inserted_at,
      updated_at: product.updated_at
    }
  end
end
