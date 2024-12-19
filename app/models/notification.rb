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

  def self.send_notifications
    notifications = Notification.date_of_notification
    notifications.each do |notification|
      user = notification.item&.user
      Rails.logger.debug("Notification ID: #{notification.id}, User: #{user.inspect}, UID: #{user&.uid}")
      line_user_id = user&.uid
      if line_user_id.present?
        Rails.logger.debug("メッセージ作成開始: Notification ID #{notification.id}")
        # インスタンスメソッドとして呼び出す
        message = notification.item.create_notification_message
        Rails.logger.debug("生成された通知メッセージ: #{message}")
        begin
          LinebotController.new.push_message(line_user_id, message)
        rescue => error
          Rails.logger.error("LINE通知送信エラー: #{error.message}")
        end
      else
        Rails.logger.error("LINE通知送信エラー: UIDが見つかりません (Notification ID: #{notification.id})")
      end
    end
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
end
