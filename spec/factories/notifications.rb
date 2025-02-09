FactoryBot.define do
  factory :notification do
    next_notification_day { Date.tomorrow }
    last_notification_day { Date.yesterday }
    notification_interval { 1 }
    association :item
  end
end
