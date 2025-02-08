FactoryBot.define do
  factory :item do
    category { "shampoo" }
    name { "Test_item" }
    volume { 300 }
    used_count_per_weekly { 7 }
    memo { "test" }
  end
end
