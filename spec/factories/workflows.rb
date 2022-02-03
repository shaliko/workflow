default_steps = <<~TEXT
  {
    "step1": {
      "call": "http.post",
      "args": {
        "url": "https://jsonplaceholder.typicode.com/comments",
        "body": {
          "postId": "${args.postId}",
          "name": "${args.userName}",
          "email": "${args.userEmail}",
          "body": "${args.comment}"
        }
      }
    },
    "step2": {
      "call": "http.get",
      "args": {
        "url": "${'https://fakestoreapi.com/products?limit=' + (Math.round(Math.random() * 10) + 1)}"
      },
      "result": "products"
    },
    "step3": {
      "switch": [
        {
          "condition": "${args.postId % 2 === 0}",
          "next": "evenPostIdReturn"
        },
        {
          "condition": "${products.length != 5}",
          "next": "step2"
        }
      ]
    },
    "returnOutput": {
      "return": "${'Products count ' + products.length}"
    },
    "evenPostIdReturn": {
      "return": "${'Products count fetched ' + products.length}"
    }
  }
TEXT

FactoryBot.define do
  factory :workflow do
    name { FFaker::Product.product_name }
    steps { default_steps }
  end
end
