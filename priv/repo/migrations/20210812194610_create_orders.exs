defmodule PeekHome.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string
      add :total, :integer
      add :balance_due, :integer

      timestamps()
    end

  end
end
