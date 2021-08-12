defmodule PeekHome.PaymentsTest do
  use PeekHome.DataCase

  import PeekHomeWeb.Fixtures

  alias PeekHome.Payments

  describe "payments" do
    setup do
      %{order: order_fixture()}
    end

    test "list_payments/1 returns all payments", %{order: order} do
      payment = payment_fixture(order)
      assert Payments.list_payments(order.id) == [payment]
    end

    test "create_payment/1 with valid data creates a payment", %{order: order} do
      assert payment = Payments.create_payment!(%{order_id: order.id, amount: 10})
      assert payment.amount == 10
      assert payment.note == nil
    end
  end
end
