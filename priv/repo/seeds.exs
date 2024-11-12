# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kantox.Repo.insert!(%Kantox.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Kantox.Products.Product

Kantox.Repo.insert(Product.changeset(%Product{code: "GR1", name: "Green tea", price: 3.11}))

Kantox.Repo.insert(Product.changeset(%Product{code: "SR1", name: "Strawberries", price: 5.00}))

Kantox.Repo.insert(Product.changeset(%Product{code: "CF1", name: "Coffee", price: 11.23}))
