defmodule PeekHomeWeb.MakePaymentTest do
  use PeekHomeWeb.ConnCase

  import PeekHomeWeb.Fixtures, only: [order_fixture: 0]

  @mutation """
  mutation($id: String, $bal: Int) {
    makePayment(orderId: $id, newBalance: $bal, note: "test payment") {
      id
      total
      balanceDue
      description
      paymentsApplied {
        amount
        note
        insertedAt
      }
    }
  }
  """

  describe "make payment:" do
    test "success", %{conn: conn} do
      order = order_fixture()
      vars = %{"id" => order.id, "bal" => 50}
      conn = post(conn, "/api", query: @mutation, variables: vars)

      assert %{"data" => %{"makePayment" => order_res}} = json_response(conn, 200)
      assert order_res["balanceDue"] == order_res["total"] - 50
    end

    test "invalid order ID", %{conn: conn} do
      bad_vars = %{"id" => Ecto.UUID.generate(), "bal" => 50}
      conn = post(conn, "/api", query: @mutation, variables: bad_vars)

      assert %{"errors" => _} = json_response(conn, 200)
    end

    test "new balance not less", %{conn: conn} do
      order = order_fixture()
      bad_vars = %{"id" => order.id, "bal" => 5000}
      conn = post(conn, "/api", query: @mutation, variables: bad_vars)

      assert %{"errors" => _} = json_response(conn, 200)
    end

    test "idempotence", %{conn: conn} do
      order = order_fixture()
      vars = %{"id" => order.id, "bal" => 50}

      conn = post(conn, "/api", query: @mutation, variables: vars)
      assert %{"data" => data_1} = json_response(conn, 200)

      conn = post(conn, "/api", query: @mutation, variables: vars)
      assert %{"data" => data_2} = json_response(conn, 200)

      assert data_1 == data_2
    end

    test "note not necessary", %{conn: conn} do
      order = order_fixture()

      no_note = """
        mutation($id: String, $bal: Int) {
          makePayment(orderId: $id, newBalance: $bal) {
            id
          }
        }
      """

      vars = %{"id" => order.id, "bal" => 50}
      conn = post(conn, "/api", query: no_note, variables: vars)
      assert %{"data" => %{"makePayment" => _}} = json_response(conn, 200)
    end
  end
end
