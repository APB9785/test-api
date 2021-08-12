defmodule PeekHome.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "payments" do
    field :amount, :integer
    field :note, :string
    belongs_to :order, PeekHome.Orders.Order

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :note, :order_id])
    |> validate_required([:amount, :order_id])
  end
end
