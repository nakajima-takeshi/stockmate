FactoryBot.define do
  factory :notification do
    next_notification_day { Date.tomorrow }
    last_notification_day { Date.yesterday }
    notification_interval { 14 }
    association :item
  end
end
