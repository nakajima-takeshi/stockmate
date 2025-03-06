class LineNotificationService
    include Line::ClientConcern

    def initialize(notification)
        @notification = notification
    end

    def call
        push_line_notification(@notification)
    end

    private

    def push_line_notification(notification)
        user = @notification.item&.user
        line_user_id = user&.uid

        if line_user_id.present?
            message = create_notification_message
            begin
                client.push_message(line_user_id, {
                    type: "text",
                    text: message
                })
                @notification.save_last_notification_day
            rescue => error
                Rails.logger.error("LINE通知送信エラー: #{error.message}")
            end
        else
            Rails.logger.error("LINE通知送信エラー: UIDが見つかりません(Notification ID: #{@notification.id})")
        end
    end

    def create_notification_message
        item = @notification.item
        message = "商品名【#{item.name}】の在庫補充をしてください。\n"
        message += "カテゴリー : #{I18n.t("categories.#{item.category}", default: item.category)}\n"

        if item.memo.present?
            message += "メモ書きがあります。\n"
            message += "メモ内容 : #{item.memo}\n"
        end
        message
    end
end
