defmodule PeekHomeWeb.ListOrdersTest do
  use PeekHomeWeb.ConnCase

  import PeekHomeWeb.Fixtures

  @query """
  {
    orders {
      id
      total
      description
      balanceDue
      paymentsApplied {
        amount
        note
        insertedAt
      }
    }
  }
  """

  describe "query orders:" do
    test "single order", %{conn: conn} do
      order = order_fixture()
      conn = post(conn, "/api", %{"query" => @query})

      assert %{"data" => %{"orders" => orders}} = json_response(conn, 200)
      assert length(orders) == 1
    end

    test "several orders", %{conn: conn} do
      order_1 = order_fixture()
      order_2 = order_fixture()
      order_3 = order_fixture()
      conn = post(conn, "/api", %{"query" => @query})

      assert %{"data" => %{"orders" => orders}} = json_response(conn, 200)
      assert length(orders) == 3
    end

    test "order with payments", %{conn: conn} do
      order = order_fixture()
      payment_1 = payment_fixture(order)
      payment_2 = payment_fixture(order)
      conn = post(conn, "/api", %{"query" => @query})

      assert %{"data" => %{"orders" => [%{"paymentsApplied" => payments}]}} =
               json_response(conn, 200)

      assert length(payments) == 2
    end
  end
end
