defmodule Kantox.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :code, :string, null: false
      add :name, :string, null: false

      add :price, :decimal,
        null: false,
        check: %{name: "price_greater_than_zero", expr: "price > 0"}

      timestamps()
    end

    create index(:products, [:code])
  end
end
