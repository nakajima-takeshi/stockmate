class Notification < ApplicationRecord
  belongs_to :item

  validates :next_notification_day, presence: true
  validate :past_date_next_notification_day
  validate :too_far_next_notification_day
  # 通知日の更新
  def item_update_next_notification_day
    self.update(next_notification_day: item.calculate_next_notification_day)
  end

  def notification_update_next_notification_day(new_notification_day)
    interval = (new_notification_day - Date.today).to_i
    self.update(next_notification_day: new_notification_day, notification_interval: interval)
  end

  private

  def past_date_next_notification_day
    if next_notification_day < Date.today
      errors.add(:next_notification_day, :past_date)
    end
  end

  def too_far_next_notification_day
    if next_notification_day > Date.today + 365.days
      errors.add(:next_notification_day, :too_far)
    end
  end
end
