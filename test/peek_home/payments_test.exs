defmodule PeekHome.PaymentsTest do
  use PeekHome.DataCase

  alias PeekHome.Payments

  describe "payments" do
    alias PeekHome.Payments.Payment

    @valid_attrs %{amount: 42, note: "some note"}
    @update_attrs %{amount: 43, note: "some updated note"}
    @invalid_attrs %{amount: nil, note: nil}

    def payment_fixture(attrs \\ %{}) do
      {:ok, payment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Payments.create_payment()

      payment
    end

    test "list_payments/0 returns all payments" do
      payment = payment_fixture()
      assert Payments.list_payments() == [payment]
    end

    test "get_payment!/1 returns the payment with given id" do
      payment = payment_fixture()
      assert Payments.get_payment!(payment.id) == payment
    end

    test "create_payment/1 with valid data creates a payment" do
      assert {:ok, %Payment{} = payment} = Payments.create_payment(@valid_attrs)
      assert payment.amount == 42
      assert payment.note == "some note"
    end

    test "create_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_payment(@invalid_attrs)
    end

    test "update_payment/2 with valid data updates the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{} = payment} = Payments.update_payment(payment, @update_attrs)
      assert payment.amount == 43
      assert payment.note == "some updated note"
    end

    test "update_payment/2 with invalid data returns error changeset" do
      payment = payment_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_payment(payment, @invalid_attrs)
      assert payment == Payments.get_payment!(payment.id)
    end

    test "delete_payment/1 deletes the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{}} = Payments.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_payment!(payment.id) end
    end

    test "change_payment/1 returns a payment changeset" do
      payment = payment_fixture()
      assert %Ecto.Changeset{} = Payments.change_payment(payment)
    end
  end
end
