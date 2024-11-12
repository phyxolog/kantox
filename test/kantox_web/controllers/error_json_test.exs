defmodule KantoxWeb.ErrorJSONTest do
  use KantoxWeb.ConnCase, async: true

  test "renders 404" do
    assert KantoxWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert KantoxWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end

  test "renders changeset" do
    types = %{
      product_codes: {:array, :string}
    }

    changeset =
      {%{}, types}
      |> Ecto.Changeset.cast(%{}, Map.keys(types))
      |> Ecto.Changeset.validate_required(Map.keys(types))

    assert KantoxWeb.ErrorJSON.render("changeset.json", %{changeset: changeset}) ==
             %{errors: %{product_codes: ["can't be blank"]}}
  end
end
