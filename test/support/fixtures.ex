defmodule PeekHomeWeb.Fixtures do
  alias PeekHome.{Orders, Payments}

  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        description: "test order #{System.unique_integer()}",
        total: 100,
        balance_due: 100
      })
      |> Orders.create_new_order()

    order
  end

  def payment_fixture(order, attrs \\ %{}) do
    attrs
    |> Enum.into(%{order_id: order.id, amount: 50, note: "test payment"})
    |> Payments.create_payment!()
  end
end
