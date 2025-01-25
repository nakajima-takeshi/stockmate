class Notification < ApplicationRecord
  belongs_to :item

  validate :valid_update_next_notification_day

  def item_update_next_notification_day
    new_notification_day = item.calculate_next_notification_day
    interval = (new_notification_day - Date.today).to_i
    self.update(next_notification_day: item.calculate_next_notification_day,
                notification_interval: interval)
  end

  def save_last_notification_day
    self.update(last_notification_day: Date.today)
  end

  def notification_update_next_notification_day(new_notification_day)
    interval = (new_notification_day - Date.today).to_i
    self.update(next_notification_day: new_notification_day,
                notification_interval: interval)
  end

  def push_line_message
    user = item&.user
    line_user_id = user&.uid
    Rails.logger.info("LINE通知送信: UID: #{line_user_id}")
    if line_user_id.present?
      message = self.create_notification_message

      @client ||= Line::Bot::Client.new do |config|
        config.channel_secret = ENV["LINE_BOT_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_BOT_CHANNEL_TOKEN"]
      end

      begin
        message = {
          type: "text",
          text: message
        }
        response = @client.push_line_message(line_user_id, message)
        Rails.logger.info("LINE通知送信成功: #{response.body}")
        self.save_last_notification_day
      rescue => error
        Rails.logger.error("LINE通知送信エラー: #{error.message}")
      end
    else
      Rails.logger.error("LINE通知送信エラー: UIDが見つかりません(Notification ID: #{self.id})")
    end
  end

  def create_notification_message
    message = "#{item.name}の在庫補充をしてください\n"
    message += "メモ書きがあります。メモ内容 : #{item.memo}\n" if item.memo.present?
    message += "https://stockmate.dev/item\n"
    Rails.logger.info("LINE通知メッセージ: #{message}")
    message
  end

  # 本日の通知対象をまとめて一括で通知する
  def self.send_notifications
    notifications = date_of_notification
    notifications.each do |notification|
      notification.push_line_message
    end
  end

  private

  def valid_update_next_notification_day
    if next_notification_day.blank?
      errors.add(:next_notification_day, :blank_field)
    elsif next_notification_day < Date.today# + 1.days
      errors.add(:next_notification_day, :past_date)
    elsif next_notification_day > Date.today + 365.days
      errors.add(:next_notification_day, :too_far)
    end
  end

  def self.date_of_notification
    notifications = where(next_notification_day: Date.today)
    Rails.logger.info("本日の通知対象：#{notifications.count}件")
    notifications
  end
end
