defmodule KantoxWeb.FallbackController do
  @moduledoc false

  use Phoenix.Controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: KantoxWeb.ErrorJSON)
    |> render("changeset.json", changeset: changeset)
  end
end
