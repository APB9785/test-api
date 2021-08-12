defmodule PeekHomeWeb.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(PeekHomeWeb.Schema.Types)

  alias PeekHomeWeb.Resolvers

  query do
    @desc "List all orders"
    field :orders, list_of(:order) do
      resolve(&Resolvers.list_orders/3)
    end
  end

  mutation do
    @desc "Create a new order"
    field :create_order, type: :order do
      arg(:description, non_null(:string))
      arg(:price, non_null(:integer))

      resolve(&Resolvers.create_order/3)
    end

    @desc "Make a payment for an existing order"
    field :make_payment, type: :order do
      arg(:order_id, non_null(:string))
      arg(:new_balance, non_null(:integer))
      arg(:note, :string)

      resolve(&Resolvers.make_payment/3)
    end

    @desc "Create an order and pay"
    field :order_and_pay, type: :order do
      arg(:description, non_null(:string))
      arg(:price, non_null(:integer))
      arg(:balance, non_null(:integer))
      arg(:note, :string)

      resolve(&Resolvers.order_and_pay/3)
    end
  end
end
