class Notification < ApplicationRecord
  belongs_to :item

  validates :next_notification_day, presence: true
  # 通知日の更新
  def update_next_notification_day
    self.update(next_notification_day: item.calculate_next_notification_day)
  end
end
