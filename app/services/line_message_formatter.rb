class LineMessageFormatter
    def initialize(items)
        @items = items
    end

    def call
        if @items.present?
            create_items_message(@items)
        else
            "登録されている日用品はありません。"
        end
    end
    # 登録一覧のメッセージ
    def create_items_message
        @items.map do |item|
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
