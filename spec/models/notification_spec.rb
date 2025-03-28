require 'rails_helper'

RSpec.describe Notification, type: :model do
  before do
    mock_auth_hash
  end
  let(:auth) { OmniAuth.config.mock_auth[:line] }
  let(:user) { User.from_omniauth(auth) }
  let(:item) { create(:item, user: user) }
  let(:notification) { build(:notification) }

  describe 'バリデーションチェック' do
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
      notification = build(:notification, next_notification_day: Date.today + 366)
      expect(notification).to be_invalid
      expect(notification.errors.full_messages).to include('通知日は１年以内の日付を入力してください')
    end
  end

  describe '通知メッセージの作成' do
    let!(:notification) { create(:notification, item: item) }

    it 'メッセージの作成に成功する' do
      allow(notification).to receive(:next_notification_day).and_return(Date.today)

      line_notification_service = LineNotificationService.new(notification)
      notification_message = line_notification_service.send(:create_notification_message)

      expect(notification_message).to include("商品名【#{item.name}】の在庫補充をしてください。\n")
      expect(notification_message).to include("カテゴリー : #{I18n.t("categories.#{item.category}", default: item.category)}\n")
      expect(notification_message).to include("メモ書きがあります。\n")
      expect(notification_message).to include("メモ内容 : #{item.memo}\n")
    end
  end
end
