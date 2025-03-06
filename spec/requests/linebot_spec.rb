require 'rails_helper'
include Line::ClientConcern

RSpec.describe "LinebotController", type: :request do
  before do
    mock_auth_hash
  end

  let(:auth) { OmniAuth.config.mock_auth[:line] }
  let(:user)  { User.from_omniauth(auth) }
  let(:user_id) { '12345' }

  describe 'handle_message_eventについて' do
    let(:event) do
      event_hash = {
        'type' => 'message',
        'message' => { 'text' => message_text },
        'source' => { 'userId' => user_id }
      }

      event_double = double(
        'Line::Bot::Event::Message',
        type: 'message',
        message: { 'text' => message_text },
        source: { 'userId' => user_id }
      )
      # `[]` メソッドをモック化
      allow(event_double).to receive(:[]).with('type').and_return(event_hash['type'])
      allow(event_double).to receive(:[]).with('message').and_return(event_hash['message'])
      allow(event_double).to receive(:[]).with('source').and_return(event_hash['source'])
      allow(event_double).to receive(:source).and_return(event_hash['source'])

      event_double # モック化したevent_doubleを返す
    end

    context '"登録確認"と入力された時' do
      let(:message_text) { '登録確認' }
      let(:item) { create(:item, user: user) }
      let!(:notification) { create(:notification, item: item) }

      it 'LineNotificationFormatterを呼び出し、登録されている日用品を返すこと' do
        controller = LinebotController.new
        items = [ item ]
        line_message_formatter = LineMessageFormatter.new(items)
        formatted_message = line_message_formatter.send(:create_items, items)

        allow(LineMessageFormatter).to receive(:new).and_return(line_message_formatter)

        response = controller.send(:handle_message_event, event)
        expect(response[:type]).to eq('text')
        expect(response[:text]).to include(formatted_message)
      end
    end

    # MESSAGE_STEPは正常に動作しているものとする
    context '"在庫補充"と入力された時' do
      let(:message_text) { '在庫補充' }

      it '商品名を尋ねるメッセージを返すこと' do
        controller = LinebotController.new
        response = controller.send(:handle_message_event, event)
        expect(response[:type]).to eq('text')
        expect(response[:text]).to eq('登録している【商品名】を入力してください。')
      end
    end

    context '”在庫補充”と入力後、【商品名】が入力された時' do
      let(:message_text) { "#{item.name}" }
      let(:item) { create(:item, user: user) }
      let!(:notification) { create(:notification, item: item) }

      it '【商品名】を入力され、在庫補充に成功すること' do
        controller = LinebotController.new
        response = controller.send(:handle_message_event, event)
        expect(response[:type]).to eq('text')
        expect(response[:text]).to include("#{item.name}を補充しました。\n次回通知日は#{item.notification.next_notification_day + 43.days}です。")
      end
    end
  end
end
