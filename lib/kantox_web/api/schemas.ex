defmodule KantoxWeb.Api.Schemas do
  @moduledoc """
  Defines the data schemas for the API using OpenAPI specifications.
  """

  # credo:disable-for-this-file Credo.Check.Readability.ModuleDoc

  alias OpenApiSpex.Schema

  require OpenApiSpex

  defmodule CheckoutRequest do
    OpenApiSpex.schema(%{
      title: "CheckoutRequest",
      description: "CheckoutRequest",
      type: :object,
      properties: %{
        product_codes: %OpenApiSpex.Schema{
          type: :array,
          items: %OpenApiSpex.Schema{type: :string},
          maxItems: 1000
        }
      },
      required: [:product_codes],
      example: %{
        "product_codes" => ["GR1", "CF1"]
      }
    })
  end

  defmodule CheckoutResponse do
    OpenApiSpex.schema(%{
      title: "CheckoutResponse",
      description: "CheckoutResponse",
      type: :object,
      properties: %{
        final_price: %Schema{type: :string, description: "Final price"}
      },
      example: %{
        "final_price" => "11.45"
      }
    })
  end

  defmodule Product do
    OpenApiSpex.schema(%{
      title: "Product",
      description: "Represents a product in the store",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        code: %Schema{type: :string, description: "Code"},
        name: %Schema{type: :string, description: "Name"},
        price: %Schema{type: :string, description: "Price"},
        inserted_at: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updated_at: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [:id, :code, :name, :price, :inserted_at, :updated_at],
      example: %{
        "id" => 1,
        "code" => "GR1",
        "name" => "Green Tea",
        "price" => "5.11",
        "inserted_at" => "2017-09-12T12:34:55Z",
        "updated_at" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule ProductsResponse do
    OpenApiSpex.schema(%{
      title: "ProductsResponse",
      description: "Response schema for multiple products with pagination",
      type: :object,
      properties: %{
        data: %Schema{
          description: "The product details",
          type: :array,
          items: Product
        },
        metadata: %Schema{
          type: :object,
          properties: %{
            page_size: %Schema{type: :integer, description: "Number of items per page"},
            page_number: %Schema{type: :integer, description: "Current page number"},
            total_entries: %Schema{type: :integer, description: "Total number of items"},
            total_pages: %Schema{type: :integer, description: "Total number of pages"}
          }
        }
      },
      example: %{
        "data" => [
          %{
            "id" => 1,
            "code" => "GR1",
            "name" => "Green Tea",
            "price" => "5.11",
            "inserted_at" => "2017-09-12T12:34:55Z",
            "updated_at" => "2017-09-13T10:11:12Z"
          },
          %{
            "id" => 2,
            "code" => "CF1",
            "name" => "Coffee",
            "price" => "12.50",
            "inserted_at" => "2017-09-12T12:34:55Z",
            "updated_at" => "2017-09-13T10:11:12Z"
          }
        ],
        "metadata" => %{
          "page_size" => 100,
          "page_number" => 1,
          "total_entries" => 3,
          "total_pages" => 2
        }
      }
    })
  end
end
