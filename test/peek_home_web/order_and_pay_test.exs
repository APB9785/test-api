defmodule PeekHomeWeb.OrderAndPayTest do
  use PeekHomeWeb.ConnCase

  @mutation """
  mutation($desc: String, $price: Int, $bal: Int) {
    orderAndPay(description: $desc, price: $price, balance: $bal) {
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

  describe "order and pay:" do
    test "success", %{conn: conn} do
      vars = %{"desc" => "test order", "price" => 100, "bal" => 75}
      conn = post(conn, "/api", query: @mutation, variables: vars)

      assert %{
               "data" => %{
                 "orderAndPay" => %{
                   "balanceDue" => 75,
                   "description" => "test order",
                   "id" => _,
                   "total" => 100,
                   "paymentsApplied" => [%{"amount" => 25}]
                 }
               }
             } = json_response(conn, 200)
    end

    test "idempotence", %{conn: conn} do
      vars = %{"desc" => "test order", "price" => 100, "bal" => 75}

      conn = post(conn, "/api", query: @mutation, variables: vars)
      assert %{"data" => %{"orderAndPay" => data_1}} = json_response(conn, 200)

      conn = post(conn, "/api", query: @mutation, variables: vars)
      assert %{"data" => %{"orderAndPay" => data_2}} = json_response(conn, 200)

      assert data_1 == data_2
      assert length(PeekHome.Orders.list_orders()) == 1
    end

    test "overpayment", %{conn: conn} do
      vars = %{"desc" => "test order", "price" => 100, "bal" => -50}

      conn = post(conn, "/api", query: @mutation, variables: vars)
      assert %{"errors" => [%{"message" => "Overpayment"}]} = json_response(conn, 200)
    end

    test "non-payment", %{conn: conn} do
      vars = %{"desc" => "test order", "price" => 100, "bal" => 100}

      conn = post(conn, "/api", query: @mutation, variables: vars)

      assert %{"errors" => [%{"message" => "New balance must be less than 100"}]} =
               json_response(conn, 200)
    end

    test "negative payment", %{conn: conn} do
      vars = %{"desc" => "test order", "price" => 100, "bal" => 150}

      conn = post(conn, "/api", query: @mutation, variables: vars)

      assert %{"errors" => [%{"message" => "New balance must be less than 100"}]} =
               json_response(conn, 200)
    end
  end
end
