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
        "url": "${'https://jsonplaceholder.typicode.com/posts/' + args.postId + '/comments'}"
      },
      "result": "comments"
    },
    "step3": {
      "switch": [
        {
          "condition": "${args.postId % 2 === 0}",
          "next": "evenPostIdReturn"
        },
        {
          "condition": "${comments.length < 5}",
          "next": "step1"
        }
      ]
    },
    "returnOutput": {
      "return": "${'Comments count ' + comments.length}"
    },
    "evenPostIdReturn": {
      "return": "${'Comments count ' + comments.length + ' for PostId ' + args.postId}"
    }
  }
TEXT

FactoryBot.define do
  factory :workflow do
    name { FFaker::Product.product_name }
    steps { default_steps }
  end
end
