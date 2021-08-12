defmodule PeekHomeWeb.Resolvers do
  alias PeekHome.{Orders, Payments}
  alias PeekHome.Orders.Order

  def list_orders(_parent, _args, _resolution) do
    {:ok, Orders.list_orders()}
  end

  def list_payments(%Order{id: id}, _args, _resolution) do
    {:ok, Payments.list_payments(id)}
  end

  def create_order(_parent, %{description: desc, price: price}, _resolution) do
    %{description: desc, total: price, balance_due: price}
    |> Orders.create_new_order()
  end

  def make_payment(_parent, args, _resolution) do
    case Orders.get_order(args.order_id) do
      %Order{} = order ->
        attempt_payment(order, args)

      nil ->
        {:error, "Order not found"}
    end
  end

  defp attempt_payment(%Order{balance_due: bal, id: id} = order, args) do
    cond do
      args.new_balance < 0 ->
        {:error, "Overpayment"}

      args.new_balance < bal ->
        p = %{order_id: id, note: args[:note], amount: bal - args.new_balance}
        Payments.create_payment!(p)
        Orders.payment_made(order, args.new_balance)

      args.new_balance == bal ->
        {:ok, order}

      args.new_balance > bal ->
        {:error, "New balance must be less than #{bal}"}
    end
  end

  def order_and_pay(_parent, %{balance: bal}, _resolution) when bal < 0 do
    {:error, "Overpayment"}
  end

  def order_and_pay(_parent, %{balance: bal, price: p}, _resolution) when bal >= p do
    {:error, "New balance must be less than #{p}"}
  end

  def order_and_pay(_parent, args, _resolution) do
    attrs = %{description: args.description, total: args.price}

    case Orders.search_for_order(attrs) do
      %Order{} = order ->
        {:ok, order}

      nil ->
        proceed_with_order(args)
    end
  end

  defp proceed_with_order(%{description: desc, price: price, balance: balance} = args) do
    o = %{description: desc, total: price, balance_due: balance}

    case Orders.create_order(o) do
      {:ok, order} ->
        %{order_id: order.id, note: args[:note], amount: price - balance}
        |> Payments.create_payment!()

        {:ok, order}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
