require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'バリデーションチェック' do
    let(:notification) { build(:notification) }

    it '設定したすべてのバリデーションが機能しているか' do
      expect(notification).to be_valid
      expect(notification.errors).to be_empty
    end

    it '次回通知予定日が今日なので失敗する' do
      notification = build(:notification, next_notification_day: Date.today)
      expect(notification).to be_invalid
      expect(notification.errors.full_messages).to include('通知日は今日以降の日付を入力してください')
    end

    it '次回通知予定日が空欄だと失敗する' do
      notification = build(:notification, next_notification_day: nil)
      expect(notification).to be_invalid
      expect(notification.errors.full_messages).to include('通知日を入力してください')
    end

    it '次回通知予定日が365日以上先だと失敗する' do
      notification = build(:notification, next_notification_day: Date.today + 366.days)
      expect(notification).to be_invalid
      expect(notification.errors.full_messages).to include('通知日は１年以内の日付を入力してください')
    end
  end
end
