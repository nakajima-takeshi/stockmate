class Notification < ApplicationRecord
  belongs_to :item

  # 通知日の更新
  def update_next_notification_day
    self.update(next_notification_day: item.calculate_next_notification_day)
    save
  end
end
