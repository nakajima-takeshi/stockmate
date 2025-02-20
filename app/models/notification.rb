class Notification < ApplicationRecord
  include Line::ClientConcern
  belongs_to :item

  validate :valid_next_notification_day

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

  def save_last_notification_day
    self.update(last_notification_day: Date.today)
  end

  def linebot_update_next_notification_day
    interval_days = item.linebot_calculate_next_notification_day
    new_notification_day = Date.today + interval_days
    self.update(
      next_notification_day: new_notification_day,
      notification_interval: interval_days)
  end

  def push_line_message
    user = item&.user
    line_user_id = user&.uid

    if line_user_id.present?
      message = self.create_notification_message
      begin
        client.push_message(line_user_id, {
          type: "text",
          text: message
        })
        self.save_last_notification_day
      rescue => error
        Rails.logger.error("LINE通知送信エラー: #{error.message}")
      end
    else
      Rails.logger.error("LINE通知送信エラー: UIDが見つかりません(Notification ID: #{self.id})")
    end
  end

  def create_notification_message
    message = "商品名【#{item.name}】の在庫補充をしてください。\n"
    message += "カテゴリー : #{I18n.t("categories.#{item.category}", default: item.category)}\n"
    if item.memo.present?
      message += "メモ書きがあります。\n"
      message += "メモ内容 : #{item.memo}\n"
    end
    message
  end

  def self.send_notifications
    notifications = date_of_notification
    notifications.each do |notification|
      notification.push_line_message
    end
  end

  private

  def valid_next_notification_day
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
end
