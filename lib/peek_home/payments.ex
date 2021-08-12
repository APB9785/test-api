defmodule PeekHome.Payments do
  @moduledoc """
  The Payments context.
  """

  import Ecto.Query, warn: false
  alias PeekHome.Repo

  alias PeekHome.Payments.Payment

  @doc """
  Returns the list of payments for a given order ID.

  ## Examples

      iex> list_payments("7180e96d-7581-4e73-bc32-5912fb546d1f")
      [%Payment{}, ...]

  """
  def list_payments(order_id) do
    Repo.all(from p in Payment, where: p.order_id == ^order_id)
  end

  @doc """
  Creates a payment and raises an error if it fails.

  ## Examples

      iex> create_payment(%{field: value})
      %Payment{}

  """
  def create_payment!(attrs \\ %{}) do
    %Payment{}
    |> Payment.changeset(attrs)
    |> Repo.insert!()
  end
end
