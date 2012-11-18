FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@factory.com" }
    sequence(:username) { |n| "user#{n}" }
    password              'foobar'
    password_confirmation 'foobar'
  end
end

FactoryGirl.define do
  factory :parent do
    fork_count 0
  end
end

FactoryGirl.define do
  factory :list do
    name 'New List'
    association :parent
  end
end
