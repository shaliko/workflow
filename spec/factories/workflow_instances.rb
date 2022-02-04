FactoryBot.define do
  factory :workflow_instance do
    association :workflow

    argument do
      {
        postId: rand(1..99),
      userEmail: FFaker::Internet.email,
      userName: FFaker::Internet.user_name,
      comment: FFaker::Lorem.sentence
      }
    end
  end
end
