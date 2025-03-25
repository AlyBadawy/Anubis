FactoryBot.define do
  factory :role do
    role_name { Faker::Job.position }

    trait :admin do
      role_name { "Admin" }
    end

    trait :user do
      role_name { "User" }
    end
  end
end
