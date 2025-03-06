# spec/services/line_message_formatter_spec.rb
require 'rails_helper'

RSpec.describe LineMessageFormatter, type: :service do
    before do
        mock_auth_hash
    end

    let(:auth) { OmniAuth.config.mock_auth[:line] }
    let(:user) { User.from_omniauth(auth) }
    let(:item) { create(:item, user: user) }
    let!(:notification) { create(:notification, item: item) }

    describe 'line_message_formatterについて' do
        it '正しくフォーマットされたアイテムリストを返す' do
            items = [item] # item_listの形式に合わせる
            line_message_formatter = LineMessageFormatter.new(items)
            formatted_message = line_message_formatter.create_items(items)

            expect(formatted_message).to include("商品名: 【#{item.name}】")
            expect(formatted_message).to include("カテゴリー: #{I18n.t("categories.#{item.category}", default: item.category)}")
            expect(formatted_message).to include("次回通知日: #{item.notification.next_notification_day}")
            expect(formatted_message).to include("メモ内容: #{item.memo}")
            expect(formatted_message).to include("-----------------")
        end
    end
end
