class Notification < ApplicationRecord
  include Line::ClientConcern
  belongs_to :item

  validate :valid_next_notification_day

  # 通知日を計算する処理群
  def item_update_next_notification_day
    new_notification_day = item.calculate_next_notification_day
    interval = (new_notification_day - Date.today).to_i
    self.update(next_notification_day: new_notification_day,
                notification_interval: interval)
  end

  def notification_update_next_notification_day(new_notification_day)
    interval = (new_notification_day - Date.today).to_i
    self.update(next_notification_day: new_notification_day,
                notification_interval: interval)
  end

  def linebot_update_next_notification_day
    interval_days = item.linebot_calculate_next_notification_day
    new_notification_day = Date.today + interval_days
    self.update(
      next_notification_day: new_notification_day,
      notification_interval: interval_days)
  end

  def save_last_notification_day
    self.update(last_notification_day: Date.today)
  end


  # LINE通知を送信する処理群
  def push_line_message
    service = LineNotificationService.new(self)
    service.call
  end

  def self.send_notifications
    notifications = date_of_notification
    notifications.each do |notification|
      notification.push_line_message
    end
  end

  private

  def self.date_of_notification
    where(next_notification_day: Date.today)
  end

  def valid_next_notification_day
    if next_notification_day.blank?
      errors.add(:next_notification_day, :blank_field)
    elsif next_notification_day < Date.today + 1
      errors.add(:next_notification_day, :past_date)
    elsif next_notification_day > (Date.today + 365)
      errors.add(:next_notification_day, :too_far)
    end
  end
end
