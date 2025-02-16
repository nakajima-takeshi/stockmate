FactoryBot.define do
  factory :notification do
    next_notification_day { Date.today + 7.days }
    last_notification_day { Date.today - 7.days }
    notification_interval { 14 }
    association :item
  end
end
