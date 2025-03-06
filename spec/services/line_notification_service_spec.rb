require 'rails_helper'
include Line::ClientConcern

RSpec.describe LineNotificationService, type: :service do
    before do
        mock_auth_hash
    end

    let(:auth) { OmniAuth.config.mock_auth[:line] }
    let(:user) { create(:user) }
    let(:item) { create(:item, user: user) }
    let(:notification) { create(:notification, item: item) }

    describe 'line_notification_serviceについて' do
        it '通知を送信すること' do
            service = LineNotificationService.new(notification)
            service_double = double('Line::Bot::Client')

            allow_any_instance_of(LineNotificationService).to receive(:client).and_return(service_double)

            expect(service_double).to receive(:push_message)
            result = service.call
            expect(result).to be true
        end
    end

    describe 'create_notification_messageについて' do
        it '正しい通知メッセージを生成すること' do
            service = LineNotificationService.new(notification)
            message = service.send(:create_notification_message)

            expect(message).to include("商品名【#{item.name}】の在庫補充をしてください。")
            expect(message).to include("カテゴリー : #{I18n.t("categories.#{item.category}", default: item.category)}")
            expect(message).to include("メモ内容 : #{item.memo}")
        end
    end
end
