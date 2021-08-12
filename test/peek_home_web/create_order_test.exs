defmodule PeekHomeWeb.CreateOrderTest do
  use PeekHomeWeb.ConnCase

  @mutation """
  mutation($desc: String, $price: Int) {
    createOrder(description: $desc, price: $price) {
      id
      total
      balanceDue
      description
    }
  }
  """

  describe "create order:" do
    test "success", %{conn: conn} do
      vars = %{"desc" => "test order", "price" => 100}
      conn = post(conn, "/api", query: @mutation, variables: vars)

      assert %{
               "data" => %{
                 "createOrder" => %{
                   "balanceDue" => x,
                   "description" => "test order",
                   "id" => _,
                   "total" => x
                 }
               }
             } = json_response(conn, 200)
    end

    test "idempotence", %{conn: conn} do
      vars = %{"desc" => "test order", "price" => 100}

      conn = post(conn, "/api", query: @mutation, variables: vars)
      assert %{"data" => %{"createOrder" => data_1}} = json_response(conn, 200)

      conn = post(conn, "/api", query: @mutation, variables: vars)
      assert %{"data" => %{"createOrder" => data_2}} = json_response(conn, 200)

      assert data_1 == data_2
      assert length(PeekHome.Orders.list_orders()) == 1
    end

    test "bad argument type", %{conn: conn} do
      vars = %{"desc" => 100, "price" => "asdf"}
      conn = post(conn, "/api", query: @mutation, variables: vars)
      assert %{"errors" => _} = json_response(conn, 200)
    end

    test "missing arguments", %{conn: conn} do
      missing_arg = """
        mutation {
          createOrder(price: 100) {
            id
          }
        }
      """

      conn = post(conn, "/api", query: missing_arg)
      assert %{"errors" => _} = json_response(conn, 200)
    end
  end
end
