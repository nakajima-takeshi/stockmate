class Notification < ApplicationRecord
  belongs_to :item

  validate :valid_update_next_notification_day

  # 通知日の更新
  def item_update_next_notification_day
    self.update(next_notification_day: item.calculate_next_notification_day)
  end

  def notification_update_next_notification_day(new_notification_day)
    interval = (new_notification_day - Date.today).to_i
    self.update(next_notification_day: new_notification_day, notification_interval: interval)
  end

  private

  # カスタムバリデーション
  def valid_update_next_notification_day
    if next_notification_day.blank?
      errors.add(:next_notification_day, :blank_field)
    elsif next_notification_day < Date.today + 1.days
      errors.add(:next_notification_day, :past_date)
    elsif next_notification_day > Date.today + 365.days
      errors.add(:next_notification_day, :too_far)
    end
  end

  def self.date_of_notification
    where(next_notification_day: Date.today)
  end

  def create_notification_message
    message = "#{item.name}の残量が少なくなっています\n"
    message += " メモ: #{item.memo}\n" if item.memo.present?
    message += "https://stockmate-a7c103b7b0ba.herokuapp.com/\n"
    message
  end

  def self.send_notifications
    notifications = Notification.date_of_notification
    notifications.each do |notification|
    message = notification.create_notification_message
      begin
        client.push_message(notification.item.user.line_user_id, {
          type: 'text',
          text: message
        })
      rescue => error
        Rails.logger.error("LINE通知送信エラー: #{error.message}")
      end
    end
  end
end
