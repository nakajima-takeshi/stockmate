class LinebotController < ApplicationController
    include Line::ClientConcern
    require "line/bot"

    skip_before_action :verify_authenticity_token

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
                text: get_inventory_list
            }
        end
    end

    def get_inventory_list
        items = Item.includes(:notification).all
        if items.present?
            format_items_message(items)
        else
            "登録されている日用品はありません。"
        end
    end

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
