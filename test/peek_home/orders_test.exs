defmodule PeekHome.OrdersTest do
  use PeekHome.DataCase

  import PeekHomeWeb.Fixtures, only: [order_fixture: 0]

  alias PeekHome.Orders
  alias PeekHome.Orders.Order

  describe "orders" do
    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      attrs = %{description: "test order", total: 100, balance_due: 100}
      assert {:ok, %Order{} = order} = Orders.create_new_order(attrs)
      assert order.balance_due == 100
      assert order.description == "test order"
      assert order.total == 100
    end
  end
end
