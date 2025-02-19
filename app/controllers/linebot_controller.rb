class LinebotController < ApplicationController
    include Line::ClientConcern
    require "line/bot"
    skip_before_action :verify_authenticity_token

    MESSAGE_STEP = {}

    def callback
        signature = request.env["HTTP_X_LINE_SIGNATURE"]
        unless client.validate_signature(request_body, signature)
            head :bad_request
            return
        end
        events = client.parse_events_from(request_body)
        events.each do |event|
            client.reply_message(event["replyToken"], message(event))
        end
    end

    private

    def request_body
        request.body.read
    end

    def message(event)
        case event
        when Line::Bot::Event::Message
            case event.type
            when Line::Bot::Event::MessageType::Text
                handle_message_event(event)
            end
        end
    end

    def handle_message_event(event)
        user_id = event["source"]["userId"]
        case event.message["text"]
        when "登録確認"
            {
                type: "text",
                text: get_inventory_list(event)
            }
        when "在庫補充"
            MESSAGE_STEP[user_id] = true
            message = {
                type: "text",
                text: "登録している【商品名】を入力してください。"
            }
        else
            if MESSAGE_STEP[user_id] == true
                result = handle_message_item_name(event)
                MESSAGE_STEP[user_id] = false
                result
            else
                message = {
                    type: "text",
                    text: "まずはメニューから操作を選択してください。"
                }
            end
        end
    end

    def handle_message_item_name(event)
        user = User.find_by(uid: event["source"]["userId"])

        if user.nil?
            return {
                type: "text",
                text: "まずはユーザー登録をお願いします！"
            }
        end

        item_name = event.message["text"]
        item = Item.joins(:notification)
                   .includes(:notification)
                   .find_by(name: item_name, user_id: user.id)

        if item.nil?
            return {
                type: "text",
                text: "#{item_name}は登録されていません。\n登録一覧で確認をお願いします。"
            }
        end

        item.notification.linebot_update_next_notification_day
        {
            type: "text",
            text: "#{item.name}を補充しました。\n次回通知日は#{item.notification.next_notification_day}です。"
        }
    end

    def get_inventory_list(event)
        user = User.find_by(uid: event["source"]["userId"])

        if user.nil?
            return "まずはユーザー登録をお願いします！"
        end

        items = user.items.joins(:notification)
                          .includes(:notification)
                          .order("notifications.next_notification_day ASC")

        if items.present?
            format_items_message(items)
        else
            "登録されている日用品はありません。"
        end
    end

    # 登録一覧のメッセージ
    def format_items_message(items)
        items.map do |item|
            item_lists = [
                "商品名: 【#{item.name}】",
                "カテゴリー: #{I18n.t("categories.#{item.category}", default: item.category)}",
                "次回通知日: #{item.notification.next_notification_day}"
            ]

            if item.memo.present?
                item_lists << "メモ内容: #{item.memo}"
            end

            item_lists << "-----------------"
            item_lists.join("\n")
        end.join("\n")
    end
end
