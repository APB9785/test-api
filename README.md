# Test API

## Query to fetch all orders
```
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
```
## Mutation to create an order
```
mutation {
  createOrder(description: String, price: Integer) {
    id
    total
    balanceDue
    description
  }
}
```
## Mutation to apply a payment to an order
```
mutation {
  makePayment(orderId: String, newBalance: Integer, note: String) {
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
```
## Don't expose auto-incrementing IDs through your API
Order and payment IDs handled by Ecto with `:binary_id`
## All mutations should be idempotent
Test suite contains idempotence tests for all mutations
## Provide an atomic "place order and pay" mutation
```
mutation {
  orderAndPay(description: String, price: Integer, balance: Integer) {
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
```
Tests for failure cases are included
## Explore subscriptions
```
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
```
Tests included
