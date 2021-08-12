defmodule PeekHome.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false

  alias PeekHome.Orders.Order
  alias PeekHome.Repo

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates an order, unless the order already exists, in which case
  returns the existing order instead.

  ## Examples

      iex> create_new_order(%{field: value})
      {:ok, %Order{}}

      iex> create_new_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_new_order(attrs \\ %{}) do
    case search_for_order(attrs) do
      %Order{} = order ->
        {:ok, order}

      nil ->
        %Order{}
        |> Order.changeset(attrs)
        |> Repo.insert()
    end
  end

  @doc """
  Checks for an order with given field data.

  ## Examples

      iex> search_for_order(%{})
      %Order{}
  """
  def search_for_order(%{description: desc, total: total}) do
    Repo.one(from o in Order, where: o.description == ^desc and o.total == ^total)
  end
end
