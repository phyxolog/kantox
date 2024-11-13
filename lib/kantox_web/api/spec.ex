defmodule KantoxWeb.Api.Spec do
  @moduledoc false

  alias OpenApiSpex.{Components, Info, MediaType, OpenApi, Paths, Response, Schema, Server}

  @behaviour OpenApi

  @impl OpenApi
  def spec do
    OpenApiSpex.resolve_schema_modules(%OpenApi{
      info: %Info{
        title: "Kantox",
        version: "0.1.0"
      },
      servers: [
        Server.from_endpoint(KantoxWeb.Endpoint)
      ],
      paths: Paths.from_router(KantoxWeb.Router),
      components: %Components{
        responses: %{
          "unprocessable_entity" => %Response{
            description: "Unprocessable Entity",
            content: %{"application/json" => %MediaType{schema: %Schema{type: :object}}}
          }
        }
      }
    })
  end
end
