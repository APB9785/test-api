defmodule PeekHomeWeb.SubscriptionTest do
  use PeekHomeWeb.ChannelCase

  import PeekHomeWeb.Fixtures, only: [order_fixture: 0]

  alias Absinthe.Phoenix.SubscriptionTest

  @subscription """
    subscription {
      activity {
        id
        description
        total
        balanceDue
        paymentsApplied {
          amount
          note
          insertedAt
        }
      }
    }
  """

  describe "subscription:" do
    setup do
      {:ok, socket} = connect(PeekHomeWeb.UserSocket, %{})
      {:ok, socket} = SubscriptionTest.join_absinthe(socket)

      ref = SubscriptionTest.push_doc(socket, @subscription)
      assert_reply ref, :ok, %{subscriptionId: sub_id}, 1000

      %{socket: socket, sub_id: sub_id}
    end

    test "order created", %{socket: socket, sub_id: sub_id} do
      mutation = """
        mutation {
          createOrder(description: "test789", price: 100) {
            id
          }
        }
      """

      ref = SubscriptionTest.push_doc(socket, mutation)
      assert_reply(ref, :ok, %{data: %{"createOrder" => %{"id" => _}}}, 1000)

      assert_push("subscription:data", push)

      assert %{result: res, subscriptionId: ^sub_id} = push
      assert %{data: %{"activity" => %{"description" => "test789"}}} = res
    end

    test "payment applied", %{socket: socket, sub_id: sub_id} do
      order = order_fixture()

      mutation = """
        mutation($id: String, $bal: Int) {
          makePayment(orderId: $id, new_balance: $bal, note: "test payment") {
            id
            balanceDue
            paymentsApplied {
              amount
            }
          }
        }
      """

      vars = %{"id" => order.id, "bal" => 0}
      ref = SubscriptionTest.push_doc(socket, mutation, variables: vars)
      assert_reply(ref, :ok, %{data: %{"makePayment" => %{"id" => _}}}, 1000)

      assert_push("subscription:data", push)

      assert %{result: res, subscriptionId: ^sub_id} = push

      assert %{
               data: %{
                 "activity" => %{
                   "balanceDue" => 0,
                   "paymentsApplied" => [%{"amount" => 100}]
                 }
               }
             } = res
    end

    test "order and pay", %{socket: socket, sub_id: sub_id} do
      mutation = """
        mutation {
          orderAndPay(description: "XYZ", price: 100, balance: 0, note: "paid") {
            id
          }
        }
      """

      ref = SubscriptionTest.push_doc(socket, mutation)
      assert_reply(ref, :ok, %{data: %{"orderAndPay" => %{"id" => _}}}, 1000)

      assert_push("subscription:data", push)

      assert %{
               result: %{
                 data: %{
                   "activity" => %{
                     "description" => "XYZ",
                     "paymentsApplied" => [%{"note" => "paid"}]
                   }
                 }
               },
               subscriptionId: ^sub_id
             } = push
    end
  end
end
