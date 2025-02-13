FactoryBot.define do
    factory :user do
        uid { "12345" } 
        email { "test@example.com" }
        name { "Test User" }
        password { "12345678909876543212" }
    end
end
