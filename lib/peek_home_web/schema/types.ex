defmodule PeekHomeWeb.Schema.Types do
  use Absinthe.Schema.Notation

  alias PeekHomeWeb.Resolvers

  object :order do
    field :id, :id
    field :balance_due, :integer
    field :description, :string
    field :total, :integer

    field :payments_applied, list_of(:payment) do
      resolve(&Resolvers.list_payments/3)
    end
  end

  object :payment do
    field :amount, :integer
    field :note, :string
    field :order_id, :id
    field :inserted_at, :naive_datetime
  end
end
